#!/bin/bash

#Ask for the user"s name to create a personalized directory
read -p "Enter your name: " username
mkdir -p "submission_reminder_$username"
cd "submission_reminder_$username"
 

#make the first file
mkdir -p modules
cat > modules/functions.sh << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

#make it executable
chmod +x modules/functions.sh

#creating the second file
mkdir -p assets
cat > assets/submissions.txt << 'EOF'
Student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Emmanuel, Shell Permissions, submitted
Ade, Python, submitted
Sade, Git, not submitted
David, Shell Navigation, submitted
Malle, Intro to Linux, submitted
Nnamdi, Shell Loops, not submitted
EOF

#make it executable
chmod +x assets/submissions.txt

#creating the third  file
mkdir -p config
cat > config/config.env << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#make it executable
chmod +x config/config.env

#creating the fourth file
mkdir -p app
cat > app/reminder.sh << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#make it executable
chmod +x app/reminder.sh

#create the last file
cat > startup.sh << 'EOF'
#!/bin/bash
cd app
./reminder.sh
EOF

chmod +x startup.sh

echo "Environment successfully setup"
