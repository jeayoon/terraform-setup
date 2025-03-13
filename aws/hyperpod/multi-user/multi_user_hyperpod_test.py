import re
import csv
import datetime
import argparse
import subprocess

CSV_FILE = "/fsx/ubuntu/user_info.csv"

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
    """Load user information from the CSV file."""
    users = []
    with open(CSV_FILE, mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            users.append({
                "user": row["User"],
                "group_name": row.get("Group", ""),
            })
    return users

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

def test_run_command(cmd, shell=False):
    result = subprocess.run(cmd, capture_output=True, text=True, shell=shell)
    return result.returncode == 0

def test_group_exists(group_name):
    """Test if a group exists on the head node."""
    return test_run_command(['getent', 'group', group_name])

def test_user_exists(user_name):
    """Test if a user exists on the head node."""
    return test_run_command(['id', user_name])

def test_group_exists_on_compute_nodes(user_name, group_name, compute_node_ip):
    """Test if a group exists on the compute nodes."""    
    ssh_command = f"sudo su - {user_name} -c 'ssh -o StrictHostKeyChecking=no {compute_node_ip} getent group {group_name}'"
    return test_run_command(ssh_command, shell=True)

def test_user_exists_on_compute_nodes(user_name, compute_node_ip):
    """Test if a user exists on the compute nodes."""
    ssh_command = f"sudo su - {user_name} -c 'ssh -o StrictHostKeyChecking=no {compute_node_ip} id {user_name}'"
    return test_run_command(ssh_command, shell=True)

def test_ssh_access(user_name, compute_node_ip):
    """Test SSH access for a user on a compute node."""
    ssh_command = f"sudo su - {user_name} -c 'ssh -o StrictHostKeyChecking=no {compute_node_ip} exit'"
    return test_run_command(ssh_command, shell=True)

def main_test(users, compute_node_ips):
    """Run all tests based on the user and group information and output to a file."""
    
    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = f"test_results_{timestamp}.txt"

    # Open the file in write mode
    with open(output_file, "w") as file:
        for user_info in users:
            user = user_info["user"]
            group_name = user_info["group_name"]

            # Print and write the section header for each user test
            user_header = f"\n{'=' * 50}\nTesting for user: {user}\n{'=' * 50}\n"
            print(user_header)
            file.write(user_header)

            # Test if group and user exist on the head node
            group_test_result = f"Testing if group '{group_name}' exists on head node...\n"
            if group_name and test_group_exists(group_name):
                group_test_result += f"Group '{group_name}' exists on head node.\n"
            else:
                group_test_result += f"Group '{group_name}' does NOT exist on head node.\n"
            print(group_test_result)
            file.write(group_test_result)

            file.write("-" * 50 + "\n")

            user_test_result = f"Testing if user '{user}' exists on head node...\n"
            if test_user_exists(user):
                user_test_result += f"User '{user}' exists on head node.\n"
            else:
                user_test_result += f"User '{user}' does NOT exist on head node.\n"
            print(user_test_result)
            file.write(user_test_result)

            file.write("-" * 50 + "\n")
            
            # Test group and user existence and SSH access for each compute node
            for compute_node_ip in compute_node_ips:
                node_header = f"\nChecking compute node: {compute_node_ip}\n"
                print(node_header)
                file.write(node_header)

                # Group existence test on compute node
                group_node_result = f"  - Group '{group_name}' exists on compute node.\n" if test_group_exists_on_compute_nodes(user, group_name, compute_node_ip) else f"  - Group '{group_name}' does NOT exist on compute node.\n"
                print(group_node_result)
                file.write(group_node_result)

                # User existence test on compute node
                user_node_result = f"  - User '{user}' exists on compute node.\n" if test_user_exists_on_compute_nodes(user, compute_node_ip) else f"  - User '{user}' does NOT exist on compute node.\n"
                print(user_node_result)
                file.write(user_node_result)

                # SSH access test on compute node
                ssh_access_result = f"  - User '{user}' can SSH into compute node.\n" if test_ssh_access(user, compute_node_ip) else f"  - User '{user}' CANNOT SSH into compute node.\n"
                print(ssh_access_result)
                file.write(ssh_access_result)

                # Add divider line after each compute node
                file.write("-" * 50 + "\n")
                print("-" * 50)

    print(f"\nTest results have been saved to {output_file}")

if __name__ == "__main__":

    args = parse_args()
    partition_name = args.partition_name

    # Load users from the CSV file
    users = load_user_info()
    # Retrieve compute node IPs using 'sinfo'
    compute_node_ips = get_compute_node_ips(partition_name)

    if not compute_node_ips:
        print("No compute nodes found. Exiting.")
    else:
        main_test(users, compute_node_ips)
