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

### 🧾 Calling One Shell Script from Another

Sometimes, we may want to call or run another script **from inside our current script**. There are two main ways to do this, and each behaves differently.

---

### ✅ **1. Using `./<script-name>.sh` (Direct Execution)**

* This runs the other script as a **separate process**.
* It will have its **own Process ID (PID)**.
* **Variables** defined in that script will **not be available** in the current script.
* Useful when the other script is **independent** or performs a separate task.

#### 🔸 Example:

```bash
#!/bin/bash

echo "This is main script"
./other-script.sh
```

---

### ✅ **2. Using `source <script-name>.sh` or `. <script-name>.sh` (Sourcing)**

* This runs the script **in the same shell** as the current script.
* The **PID remains the same**.
* Any **variables or functions** defined in the sourced script will be **available** in the current script.
* Useful when you want to **reuse variables, functions, or configs** from another script.

#### 🔸 Example:

```bash
#!/bin/bash

source ./config.sh  # Or . ./config.sh

echo "Using variables from config.sh: $APP_NAME"
```

---

### 🧠 Real-World Use Cases

| Use Case                                   | Method             | Why                 |
| ------------------------------------------ | ------------------ | ------------------- |
| Run a full, separate job (e.g., backup.sh) | `./backup.sh`      | Independent process |
| Load configuration variables               | `source config.sh` | Shares variables    |
| Share common functions                     | `source utils.sh`  | Reusable code       |
| Run scripts with no shared state           | `./script.sh`      | Isolated execution  |

---

### 📌 Summary

| Method             | Same PID | Shares Variables | When to Use               |
| ------------------ | -------- | ---------------- | ------------------------- |
| `./script.sh`      | ❌        | ❌                | Isolated execution        |
| `source script.sh` | ✅        | ✅                | Share variables/functions |

---


### 📝 Bash Script Note: `set -e`

* **Command**: `set -e`
* **Purpose**: Causes the script to **exit immediately** if **any command** returns a **non-zero (error) status**.
* **Usage**: Usually placed **at the top** of a script to enable fail-fast behavior.
* **Effect**: Helps prevent the script from continuing after an error, which could lead to unintended consequences.

#### ✅ Example:

```bash
#!/bin/bash
set -e

echo "Starting..."
cp somefile.txt /destination/       # If this fails, the script exits immediately
echo "This line will only run if the above succeeded."
```

#### ⚠️ Notes:

* It does **not** apply to commands in `if`, `while`, or `until` test conditions.
* To ignore a command's failure, you can append `|| true` or use error handling logic.

```bash
rm optionalfile.txt || true
```
---

### 📝 Bash Script Note:

## `trap 'handle_error ${LINENO} "$BASH_COMMAND" "${BASH_LINENO[@]}"' ERR`

---

### 📌 Purpose:

* To catch **any command failure** in a script and call a **custom error handler** with:

  * The **line number** where the error occurred
  * The **exact command** that failed
  * The **call stack** (function call trace)

---

### 🧩 Components:

| Part                  | Meaning                                                                               |
| --------------------- | ------------------------------------------------------------------------------------- |
| `trap '...' ERR`      | Activates trap on any command with a **non-zero exit status**                         |
| `${LINENO}`           | Line number where the error occurred                                                  |
| `"$BASH_COMMAND"`     | The actual command that failed                                                        |
| `"${BASH_LINENO[@]}"` | Array of line numbers in the **call stack**, useful for tracing nested function calls |

---

### ✅ Example Implementation:

```bash
#!/bin/bash
set -e
trap 'handle_error ${LINENO} "$BASH_COMMAND" "${BASH_LINENO[@]}"' ERR

handle_error() {
  echo "❌ Error on line: $1"
  echo "💥 Failed command: $2"
  echo "📚 Call stack (most recent last): ${@:3}"
  exit 1
}

test_func() {
  echo "Inside test_func"
  false  # This will fail
}

echo "Starting script..."
test_func
echo "This will not be printed."
```

---

### 🧠 Output Example:

```
❌ Error on line: 11
💥 Failed command: false
📚 Call stack (most recent last): 8 14
```

---

### ⚠️ Notes:

* Works best when paired with `set -e` to **stop execution on failure**.
* Great for **debugging complex scripts** with multiple functions or external commands.
* The `handle_error` function can be extended to:

  * Log to a file
  * Send alerts
  * Clean up resources
* Trap **will not catch** errors inside `if`, `while`, or `until` condition checks unless explicitly managed.

---


