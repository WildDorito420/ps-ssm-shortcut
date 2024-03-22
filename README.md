# ps-ssm-shortcut
A PS Module that can store AWS Instance IDs by a short name, and connect to hosts via SSM by just entering the short name.

## Installation
1. Download the repo
2. Extract the contents to a folder in your PSModulePath
3. Import the module with `Import-Module JumpModule`

## Usage
(You can use either the function name `JumpModule` or the alias `jump` for all of these commands)
### Add Instance
Add an instance to the list of instances that can be connected to via SSM.
```powershell
jump add ShortName i-1234567890abcdef0
```

### Remove Instance
Remove an instance from the list of instances that can be connected to via SSM.
```powershell
jump remove ShortName
```

### List Saved Instances
Get the instance ID of an instance by its short name.
```powershell
jump list
```

### Connect To Instance
Connect to an instance by its short name.
```powershell
jump ShortName
```


