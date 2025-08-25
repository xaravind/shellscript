# Shell Scripting Notes

---

### Shebang (`#!/bin/bash`)

* The shebang is the path to the interpreter.
* Commands inside the shell script are interpreted and executed by the specified shell.
* Example: `#!/bin/bash` tells the system to use bash shell to run the script.

---

### Variables

* Any value that repeats in code can be declared as a variable.
* Declaring variables is a good practice, even if the value is used only once.
* Declare variables at the start (top) of the script.
* Variables can be passed:

  * From outside the script,
  * Inside the script,
  * Or via user input using `read`.
* Syntax for declaration: `key=value`
* Refer variables by prefixing with `$`, e.g., `$key`
* To hide input when reading (like passwords), use `read -s <var-name>`

---

### Special Variables (Example from `07-special-vars.sh`)

* `$@` — All variables passed to the script.
* `$#` — Number of variables passed.
* `$0` — Script name.
* `$PWD` — Current working directory.
* `$HOME` — Home directory of current user.
* `$USER` — Username running the script.
* `$HOSTNAME` — Hostname of the machine.
* `$$` — Process ID (PID) of the current script.
* `$!` — Process ID of the last background command.
* `$?` — Exit status of the last command (`0` means success, non-zero means failure).

---

### Checking Exit Status and Exiting Script

* Use `$?` to check if the last command succeeded.
* Exit the script on failure to avoid running next commands.

Example:

```bash
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run as root"
    exit 1
fi
```

---

### `$EUID` and Running as Root

* `$EUID` is the effective user ID.
* When a regular user runs `sudo some-command`, `$EUID` becomes 0 (root) for that command, but the real UID remains the same.
* Auto-elevate script to root if not already root:

```bash
if [[ $EUID -ne 0 ]]
then
    echo "[INFO] Re-running script as root..."
    exec sudo "$0" "$@"
fi
```

---

### Data Types in Shell

* Integer
* Float / Decimal
* String
* Boolean
* Array (list of values)
* Arraylist
* Set, Map, Dict (not directly supported like in other languages, but can be simulated)

---

### Arrays

* Store multiple values.
* Example:

  ```bash
  devops=("linux" "shell" "cicd")
  ```
* Access elements by index (starting from 0):

  ```bash
  ${devops[0]}  # linux
  ${devops[1]}  # shell
  ${devops[@]}  # all elements
  ```

---

### Arithmetic Operations

* Use `expr` or `$(())` for calculations.
* Examples:

  ```bash
  val=`expr 2 + 2`
  val=$(($N1 + $N2))
  ```

---

### Conditions

* Used to make decisions in scripts.
* Refer to `08-condition.sh` for examples.

---

### Functions

* A block of code reused multiple times.
* Define functions to avoid repetition.
* Call functions by name with optional arguments.

Example:

```bash
FUNC_NAME() {
    if [ $? -ne 0 ]; then
        echo "Failed"
        exit 1
    fi
}
```

Call function:

```bash
FUNC_NAME
```

---

### Loops

* Example: Loop from 1 to 20

```bash
for i in {1..20}
do
    echo $i
done
```

---

### Redirection

* `>`  — Redirect success output (overwrite)
* `1>` — Redirect success output (same as `>`)
* `2>` — Redirect error output
* `&>` — Redirect both success and error output (overwrite)
* `&>>` — Append both success and error output

Example:

```bash
echo "hi" > output.log        # overwrite success output
echo "hi" 2> error.log        # redirect error output
echo "hi" &>> output.log      # append both outputs
```

---

### Date Command (Timestamp)

* Useful to add timestamps to files.
* Format example:

```bash
date +%F-%H-%M-%S
```

* Example usage to create timestamped file:

```bash
touch filename_$(date +%F-%H-%M-%S).sh
```

---

### Colors in Shell

* Use escape sequences to add color in terminal.
* Use ANSI escape codes:
* Examples:

  * `\e[31m` — Red
  * `\e[32m` — Green

Example:

```bash
echo -e "\e[31m hi \e[32m good morning"
```
---

### **Idempotency**

* A script is **idempotent** if it gives the **same result** no matter how many times you run it.
* Example: installing a package that’s already installed should not reinstall or break anything.
* Writing idempotent scripts is good practice for automation.

---

### **Disadvantages of Shell Scripting**

* By default, the shell script **does not stop** if a command fails.
* It’s the **user's responsibility** to check if each command ran successfully.
* Use `$?` to get the exit status of the last command.

```bash
$?  # exit status
0   # success
1-127 # failure
```

---

### **Manual Exit Example**

```bash
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run as root"
    exit 1  # manually exit if condition fails
fi
```

* Here, we are **not checking `$?`**, instead we're manually deciding when to stop the script by using `exit 1`.

---

