import os
from python_terraform import Terraform

# Define the absolute directory path where Terraform configurations are located
terraform_dir = r"C:\Users\My PC\Documents\Python for devops pratice\terra-automate\Wanderlust-Mega-Project\terraform"

# Initialize the Terraform wrapper object
tf = Terraform(working_dir=terraform_dir)

def run_terraform_automation():
    print("--- STEP 1: Initializing Terraform Workspaces ---")
    # capture_output=False enables real-time progress streaming to the terminal stdout
    return_code, stdout, stderr = tf.init(capture_output=False)
    
    if return_code != 0:
        print("❌ Error: Terraform initialization failed process execution!")
        return

    print("\n--- STEP 2: Generating Execution Plan ---")
    # Exporting the structural execution blueprint locally as a best practice
    tf.plan(out="tfplan", capture_output=False)

    print("\n--- STEP 3: Applying Infrastructure (Auto-Approve Mode) ---")
    # skip_plan=True mirrors the behavior of the native '-auto-approve' CLI flag
    return_code, stdout, stderr = tf.apply(skip_plan=True, capture_output=False)

    if return_code == 0:
        print("\n✅ SUCCESS: AWS Infrastructure has been successfully provisioned.")
    else:
        print(f"\n❌ Error: Critical infrastructure deployment failure: {stderr}")

if __name__ == "__main__":
    # Validate the directory path exists on the local host before execution
    if os.path.exists(terraform_dir):
        run_terraform_automation()
    else:
        print("❌ Configuration Error: The specified target directory path does not exist. Verify paths.")
