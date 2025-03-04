# Geryon is a simple app to combine all your swift files from a directory into a single file. 

I built this becuase I had a really odd personal edge-case, and I was tired of needing to manually squish all my files into a single master. This app just lives in your status bar, and keeps a master file updated with any changes happening in your monitored directory.  

## To Use:
1. Launch Geryon and a double file icon will show up in your status bar
2. Click on the icon, and select the directory you want monitored, and a destination for your master file. 
3. Keep the app running, and changes you make to individual files will be made to the master file (in place). That is to say, that it creates line-to-line edits in the master file, so the overall structure remains the same. 

### Example1.swift
```
/// 
/// Example1.swift
/// Geryon
///
/// Created on 4/1/1976 by Johnny Appleseed
///

import foo
import bar

func doSomething() {
	SomeCodeHere
}

```
### Example2.swift
```
/// 
/// Example2.swift
/// Geryon
///
/// Created on 4/1/1976 by Johnny Appleseed
///

import foo
import bar

func doSomethingDifferent() {
	SomeCodeHereButDifferent
}

```

### Master.swift
```
///File: Example1.swift
/// 
/// Example1.swift
/// Geryon
///
/// Created on 4/1/1976 by Johnny Appleseed
///

import foo
import bar

func doSomething() {
	SomeCodeHere
}


///File: Example2.swift
///
/// Example2.swift
/// Geryon
///
/// Created on 4/1/1976 by Johnny Appleseed
///

import foo
import bar

func doSomethingDifferent() {
	SomeCodeHereButDifferent
}

```

### Example1.swift (edited)
```
/// 
/// Example1.swift
/// Geryon
///
/// Created on 4/1/1976 by Johnny Appleseed
///

import foo
import bar

func doSomethingNew() {
	SomeNewCodeHere
}

```
### Master.swift (Updated in realtime)
```
///File: Example1.swift
/// 
/// Example1.swift
/// Geryon
///
/// Created on 4/1/1976 by Johnny Appleseed
///

import foo
import bar

func doSomethingNew() {
	SomeNewCodeHere
}


///File: Example2.swift
///
/// Example2.swift
/// Geryon
///
/// Created on 4/1/1976 by Johnny Appleseed
///

import foo
import bar

func doSomethingDifferent() {
	SomeCodeHereButDifferent
}

```

