import csv
import os
import re
import argparse
import paramiko # type: ignore
import subprocess

CSV_FILE = "/fsx/ubuntu/user_info.csv"
SSH_USER = "ubuntu" 
PRIVATE_KEY_PATH = "/fsx/ubuntu/.ssh/id_rsa"
SUDOERS_UPDATE_CMD = (
        "sudo sed -i '/^%sudo\\s\\+ALL=(ALL:ALL)\\s\\+ALL/s//%sudo ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers || "
        "(echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers)"
    )

def parse_args():
    parser = argparse.ArgumentParser(description="Manage users and groups on AWS HyperPod nodes.")
    parser.add_argument(
        "--partition_name",
        type=str,
        help="Name of the SLURM partition to query compute nodes.",
        required=False,
    )
    return parser.parse_args()

def load_user_info():
    with open(CSV_FILE, mode='r') as file:
        reader = csv.DictReader(file)
        return [
            {
                "user": row["User"],
                "user_id": row.get("UID", ""),
                "group_id": row.get("GID", ""),
                "group_name": row.get("Group", ""),
                "sudo_option": row.get("SudoOption", "").lower(),
                "password": row["Password"]
            }
            for row in reader
        ]

def run_command(cmd, shell=False, input_data=None):
    result = subprocess.run(cmd, capture_output=True, text=True, shell=shell, input=input_data)
    if result.returncode != 0:
        print(f"Command '{cmd}' failed with error: {result.stderr}")
    return result.returncode == 0

def group_exists_on_headnode(group_name):
    """Check if a group exists on the headnode."""
    result = subprocess.run(['getent', 'group', group_name], capture_output=True, text=True)
    return result.returncode == 0

def user_exists_on_headnode(user):
    """Check if a user exists on the headnode."""
    result = subprocess.run(['id', user], capture_output=True, text=True)
    return result.returncode == 0

def create_group(group_name, group_id=None):
    if group_exists_on_headnode(group_name):
        print(f"Group {group_name} already exists on the head node. Skipping creation.")
        return
    cmd = ['sudo', 'groupadd', '-g', group_id, group_name] if group_id else ['sudo', 'groupadd', group_name]
    run_command(cmd)
    print(f"Creating group {group_name} on head nodes.")

def get_group_id(group_name):
    result = subprocess.run(['getent', 'group', group_name], capture_output=True, text=True)
    return result.stdout.split(':')[2] if result.returncode == 0 else None

def create_user(user, user_id, group_id, home_dir, shell="/bin/bash"):
    if user_exists_on_headnode(user):
        print(f"User {user} already exists on the head node. Skipping creation.")
        return
    cmd = ['sudo', 'useradd', user, '-d', home_dir, '--shell', shell]
    
    if os.path.exists(home_dir):
        cmd.extend(['-M'])
    else:
        cmd.extend(['-m'])
    
    if user_id:
        cmd.extend(['-u', user_id])
    if group_id:
        cmd.extend(['-g', group_id])
    run_command(cmd)
    print(f"Creating user {user} on head nodes.")

def is_password_set(user):
    """Check if the password for the given user is set."""
    try:
        result = subprocess.run(['sudo', 'grep', f'^{user}:', '/etc/shadow'], capture_output=True, text=True)
        if result.returncode == 0:
            shadow_entry = result.stdout.strip()
            password_field = shadow_entry.split(':')[1]
            # Check if the password field is not empty and does not contain special markers
            if password_field and password_field not in ['!', '*']:
                print(f"Password for user '{user}' is set.")
                return True
            else:
                print(f"Password for user '{user}' is not set.")
                return False
        else:
            print(f"Failed to retrieve password information for user '{user}'.")
            return False
    except Exception as e:
        print(f"Error checking password for user '{user}': {e}")
        return False

def set_password(user, password):
    if user_exists_on_headnode(user):
        if is_password_set(user):
            print(f"Password for user '{user}' is already set. Skipping password setup.")
        else:
            print(f"Setting password for user '{user}'...")
            command = ['sudo', 'chpasswd']
            input_data = f"{user}:{password}"
            result = subprocess.run(command, input=input_data, text=True, capture_output=True)
            
            if not result:
                print(f"Failed to set password for user '{user}'.")
            else:
                print(f"Password set for user '{user}'.")
    else:
        print(f"User {user} does not exist on the head node. Skipping password setup.")

def add_user_to_group(user, group):
    run_command(['sudo', 'usermod', '-aG', group, user])

def file_exists_with_sudo(path):
    """Check if a file or directory exists using sudo."""
    result = subprocess.run(['sudo', 'test', '-e', path], capture_output=True)
    return result.returncode == 0

def setup_ssh_key(user, home_dir):
    ssh_dir = os.path.join(home_dir, ".ssh")
    ssh_key_path = f"{ssh_dir}/id_rsa"
    public_key_path = f"{ssh_dir}/id_rsa.pub"
    authorized_keys_path = f"{ssh_dir}/authorized_keys"

    # Check if SSH key files already exist
    if file_exists_with_sudo(ssh_key_path) and file_exists_with_sudo(public_key_path) and file_exists_with_sudo(authorized_keys_path):
        print(f"SSH keys for user {user} already exist. Skipping key generation.")
        return
    
    # If not, create the SSH key pair and authorized_keys file
    run_command(['sudo', '-u', user, 'ssh-keygen', '-t', 'rsa', '-q', '-f', ssh_key_path, '-N', ''])
    run_command(f"sudo -u {user} cat {public_key_path} | sudo -u {user} tee {authorized_keys_path}", shell=True)
    print(f"Creating ssh key {user} on head nodes.")


def get_compute_node_ips(partition_name=None):
    if partition_name:
        cmd = ['sinfo', '-h', '-o', '%N', '-p', partition_name]
    else:
        cmd = ['sinfo', '-h', '-o', '%N']

    result = subprocess.run(cmd, capture_output=True, text=True)
    node_string = result.stdout.strip()
    nodes = []

    # Match patterns with ranges (e.g., ip-10-1-45-[137,150,156,187]) and individual IPs (e.g., ip-10-1-9-96)
    pattern = re.findall(r'([a-zA-Z0-9\-]+)(?:\[(.*?)\])?', node_string)

    for base, range_part in pattern:
        if range_part:
            # Expand each number in the range part (e.g., 137,150,156,187)
            ranges = range_part.split(',')
            for number in ranges:
                nodes.append(f"{base}{number}")
        else:
            # Add the individual IP as it is (e.g., ip-10-1-9-96)
            nodes.append(base)

    return nodes

def execute_ssh_command(client, command):
    stdin, stdout, stderr = client.exec_command(command)
    return stdout.read().decode().strip()

def ssh_connect(host):
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(host, username=SSH_USER, key_filename=PRIVATE_KEY_PATH)
    return client

def compute_node_group_exists(client, group_name):
    command = f"getent group {group_name}"
    result = execute_ssh_command(client, command)
    return bool(result)

def compute_node_user_exists(client, user):
    command = f"id {user}"
    result = execute_ssh_command(client, command)
    return bool(result)

def manage_user_in_compute_nodes(user, user_id, group_id, group_name, home_dir, sudo_option, compute_node_id):
    client = ssh_connect(compute_node_id)
    print(f"Checking compute node: {compute_node_id}")

    if not compute_node_group_exists(client, group_name):
        cmd = f"sudo groupadd {'-g ' + group_id if group_id else ''} {group_name}"
        execute_ssh_command(client, cmd)
        print(f"Creating group {group_name} on compute nodes.")
    else:
        print(f"Group {group_name} already exists on compute nodes. Skipping group creation.")

    if not compute_node_user_exists(client, user):
        cmd = f"sudo useradd {user} -d {home_dir} --shell /bin/bash"
        if user_id:
            cmd += f" -u {user_id}"
        if group_id:
            cmd += f" -g {group_id}"
        execute_ssh_command(client, cmd)
        print(f"Creating user {user} on compute nodes.")
    else:
        print(f"User {user} already exists on compute nodes. Skipping user creation.")

    if sudo_option == 'y':
        command = f"sudo usermod -aG sudo {user}"
        execute_ssh_command(client, command)

        execute_ssh_command(client, SUDOERS_UPDATE_CMD)
        print(f"User {user} added to sudo group with no-password configuration (updated or added if missing).")

    client.close()

def configure_sudo(user):
    add_user_to_group(user, 'sudo')

    if run_command(SUDOERS_UPDATE_CMD, shell=True):
        print(f"User {user} added to sudo group with no-password configuration on the headnode.")
    else:
        print("Failed to update sudoers file for no-password sudo configuration.")

def main():

    args = parse_args()
    partition_name = args.partition_name

    users = load_user_info()
    compute_node_ips = get_compute_node_ips(partition_name)

    for user_info in users:
        user = user_info["user"]
        user_id = user_info["user_id"]
        group_id = user_info["group_id"]
        group_name = user_info["group_name"]
        sudo_option = user_info["sudo_option"]
        password = user_info["password"]

        if group_name:
            create_group(group_name, group_id)
            group_id = get_group_id(group_name) or group_id
            print("-" * 50)

        home_dir = f"/fsx/{user}"
        
        create_user(user, user_id, group_id, home_dir)
        if user_exists_on_headnode(user):
            set_password(user, password)
            add_user_to_group(user, 'docker')
            setup_ssh_key(user, home_dir)
        
        if sudo_option == 'y':
            configure_sudo(user)

        print("-" * 50)

        for compute_node_id in compute_node_ips:
            manage_user_in_compute_nodes(user, user_id, group_id, group_name, home_dir, sudo_option, compute_node_id)
            print("-" * 50)

if __name__ == "__main__":
    main()
