
# weight-watcher

A simple CLI tool to log your weight, calculate your BMI, and display your ideal weight. This tool helps you keep track of your weight records over time and analyze your progress.

## Setup

### Adding an Alias

To simplify the usage of `weight-watcher.sh`, you can add an alias to your shell configuration.

#### For Bash

1. Open your `.bashrc` file:
    ```bash
    nano ~/.bashrc
    ```

2. Add the following line at the end of the file:
    ```bash
    alias ww='~/weight-watcher/weight-watcher.sh'
    ```

3. Save the file and apply the changes:
    ```bash
    source ~/.bashrc
    ```

#### For Fish

1. Open your `config.fish` file:
    ```fish
    nano ~/.config/fish/config.fish
    ```

2. Add the following line:
    ```fish
    alias ww='~/weight-watcher/weight-watcher.sh'
    ```

3. Save the file and apply the changes:
    ```fish
    source ~/.config/fish/config.fish
    ```

Now you can use the alias `ww` to run the `weight-watcher` tool.

## Usage

**Set your height in the weight-watcher.sh file (HEIGHT) and create a weight_log.csv file in your system, and edit the path to the file in the weight-watcher.sh file (LOG_FILE)**

### Add weight for today:

    #(in bash)
    ww add 66.6
    # Will log 66.6 kg for todays date

### Add weight for specific date

    #(in bash)
    ww add 66.6 2024-10-06
    # Will log 66.6 kg for the date: 2024-10-06

### List all records

    #(in bash)
    ww list

## Screenshot

![image](https://github.com/user-attachments/assets/f5152b80-6555-4c40-ac19-cbe33692e4a2)

