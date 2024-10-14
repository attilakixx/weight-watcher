#!/bin/bash

# Set your height in meters (for example: 1.74 for 174 cm)
HEIGHT=1.74

# File to store the weight log
LOG_FILE=/home/attilakixx/WORK/repos/myscripts/weight-watcher/weight_log.csv

# Function to calculate BMI
calculate_bmi() {
	WEIGHT=$1
	HEIGHT=$2
	BMI=$(echo "scale=2; $WEIGHT / ($HEIGHT * $HEIGHT)" | bc)
	echo $BMI
}

# Function to categorize BMI
categorize_bmi() {
	BMI=$1
	if (( $(echo "$BMI < 18.5" | bc -l) )); then
		echo "Underweight"
	elif (( $(echo "$BMI >= 18.5" | bc -l) )) && (( $(echo "$BMI < 25" | bc -l) )); then
		echo "Normal weight"
	elif (( $(echo "$BMI >= 25" | bc -l) )) && (( $(echo "$BMI < 30" | bc -l) )); then
		echo "Overweight"
	else
		echo "Obese"
	fi
}

# Function to calculate weight from a given BMI value and height
calculate_weight_for_bmi() {
	BMI=$1
	HEIGHT=$2
	WEIGHT=$(echo "scale=2; $BMI * ($HEIGHT * $HEIGHT)" | bc)
	echo $WEIGHT
}

# Display BMI categories with weight ranges based on the user's height
display_bmi_categories() {
	echo "BMI Categories (based on height: ${HEIGHT} m):"
	echo "--------------------------------------------"

	# Underweight
	MIN_UNDERWEIGHT=$(calculate_weight_for_bmi 0 $HEIGHT)
	MAX_UNDERWEIGHT=$(calculate_weight_for_bmi 18.49 $HEIGHT)
	echo "Underweight: < 18.5 BMI  (Weight: ${MIN_UNDERWEIGHT} - ${MAX_UNDERWEIGHT} kg)"

	# Normal weight
	MIN_NORMAL=$(calculate_weight_for_bmi 18.5 $HEIGHT)
	MAX_NORMAL=$(calculate_weight_for_bmi 24.9 $HEIGHT)
	echo "Normal weight: 18.5 - 24.9 BMI  (Weight: ${MIN_NORMAL} - ${MAX_NORMAL} kg)"

	# Overweight
	MIN_OVERWEIGHT=$(calculate_weight_for_bmi 25 $HEIGHT)
	MAX_OVERWEIGHT=$(calculate_weight_for_bmi 29.9 $HEIGHT)
	echo "Overweight: 25 - 29.9 BMI  (Weight: ${MIN_OVERWEIGHT} - ${MAX_OVERWEIGHT} kg)"

	# Obese
	MIN_OBESE=$(calculate_weight_for_bmi 30 $HEIGHT)
	echo "Obese: ≥ 30 BMI  (Weight: ≥ ${MIN_OBESE} kg)"
	echo ""
}

# Add a new weight entry
ww_add() {
	WEIGHT=$1
	DATE=${2:-$(date +"%Y-%m-%d")} # Use today's date if not specified

	# Check if weight is a number
	if ! [[ $WEIGHT =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
		echo "Invalid weight input. Please enter a valid number."
		exit 1
	fi

	# Calculate BMI
	BMI=$(calculate_bmi $WEIGHT $HEIGHT)

	# Add the entry to the log file
	echo "$DATE,$WEIGHT,$BMI" >> $LOG_FILE
	echo "Weight logged: $DATE, $WEIGHT kg, BMI: $BMI"
}

# List all weight entries
ww_list() {
	if [[ ! -f $LOG_FILE ]]; then
		echo "No records found. Start by adding a weight using 'ww add'."
		exit 0
	fi

	# First, display the BMI categories with weight ranges
	display_bmi_categories

	# Print the list of weight entries sorted by date
	echo "Date       | Weight | BMI  | Category"
	echo "--------------------------------------"
	
	# Read all records into an array
	ENTRIES=($(sort $LOG_FILE | cut -d',' -f2))

	# Extract the first and last weights from the sorted list
	FIRST_WEIGHT=$(echo "${ENTRIES[0]}" | cut -d',' -f1)
	LAST_WEIGHT=$(echo "${ENTRIES[-1]}" | cut -d',' -f1)

	# Calculate the weight difference
	WEIGHT_DIFF=$(echo "scale=2; $LAST_WEIGHT - $FIRST_WEIGHT" | bc)

	# Output the list of weight entries
	sort $LOG_FILE | while IFS=',' read -r DATE WEIGHT BMI; do
		CATEGORY=$(categorize_bmi $BMI)
		echo "$DATE | ${WEIGHT} kg | BMI: $BMI | $CATEGORY"
	done

	echo ""
	if (( $(echo "$WEIGHT_DIFF > 0" | bc -l) )); then
		echo "Weight gain: ${WEIGHT_DIFF} kg"
	else
		echo "Weight loss: ${WEIGHT_DIFF#-} kg"
	fi
}


# Parse the command and arguments
case "$1" in
	"add")
		if [[ -z $2 ]]; then
			echo "Usage: ww add <weight> [<date>]"
			exit 1
		fi
		ww_add "$2" "$3"
		;;
	"list")
		ww_list
		;;
	*)
		echo "Usage: ww {add <weight> [<date>] | list}"
		exit 1
		;;
esac
