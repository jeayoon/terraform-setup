import csv
import os
import subprocess
import sys
import signal

# CSV file and path settings
CSV_FILE = "/fsx/ubuntu/user_info.csv"
CONDA_ENV_PATHS = ["/fsx/{user}/pytorch-cuda12_1", "/fsx/{user}/pytorch-cuda11_8"]

# Join command list with && to execute all at once
CONDA_COMMANDS = [
    "conda create -y -p {env_path} python=3.11 && "
    "conda activate {env_path} && "
    "conda install -y pytorch=2.3.0 pytorch-cuda={cuda_version} aws-ofi-nccl torchvision torchaudio transformers datasets fsspec=2023.9.2 --strict-channel-priority --override-channels -c https://aws-ml-conda.s3.us-west-2.amazonaws.com -c nvidia -c conda-forge && "
    "pip install jupyter notebook && "
    "python -m ipykernel install --user --name '{env_name}' && "
    "conda deactivate"
]

# Ignore BrokenPipeError
signal.signal(signal.SIGPIPE, signal.SIG_DFL)

def load_user_info():
    with open(CSV_FILE, mode='r') as file:
        reader = csv.DictReader(file)
        return [{"user": row["User"], "password": row.get("Password", "")} for row in reader]

def run_command_as_user(user, password, command):
    """Run a command as a specific user with su."""
    su_command = f"echo {password} | su - {user} -c '{command}'"
    print(f"Executing as {user}: {command}")
    try:
        result = subprocess.run(su_command, shell=True, capture_output=True, text=True)
        if result.returncode != 0:
            sys.stderr.write(f"Error running command for {user}: {result.stderr}\n")
        else:
            sys.stdout.write(f"Command executed successfully for {user}: {result.stdout}\n")
    except BrokenPipeError:
        sys.stderr.write("Broken pipe error ignored\n")

def create_and_validate_env(user, password):
    user_dir = f"/fsx/{user}"
    if not os.path.exists(user_dir):
        print(f"User directory for '{user}' does not exist. Please create user first.")
        return

    # Conda environment setup for general users
    for path, cuda_version in zip(CONDA_ENV_PATHS, ["12.1", "11.8"]):
        env_path = path.format(user=user)
        if not os.path.exists(env_path):
            cmd = " && ".join([cmd_template.format(env_path=env_path, cuda_version=cuda_version, env_name=env_path.split("/")[-1]) for cmd_template in CONDA_COMMANDS])
            run_command_as_user(user, password, cmd)
            print(f"Environment {env_path} created and configured for user {user}.")
        else:
            print(f"Environment {env_path} already exists for user {user}. Skipping setup.")

def main():
    users = load_user_info()
    for user_info in users:
        user = user_info["user"]
        password = user_info["password"]
        create_and_validate_env(user, password)

if __name__ == "__main__":
    main()
