# iOS app of Tango LinkedIn Game - basic version
<img width="395" alt="salsa-preview" src="https://github.com/user-attachments/assets/7d8bcc98-9a7d-4468-981f-1a42c199d51f" />

## Features available
An interactive game developed using SwiftUI where the user must complete rows and columns with opposite icons. Each row and column must contain exactly three icons of one type and three of another. If all rows and columns are valid, the game announces a win.

1. **6x6 Grid of Icons**

The grid consists of 36 cells, arranged in a 6x6 matrix.
Each cell is a button that, when pressed, changes the icon between 3 different options.
Icons are selected from a set of SF Symbols (e.g. sun.max.fill, moon.fill, "").

2. **Icon Cycling**

Every time a button is pressed, the icon changes in the following cyclic order:
Empty Icon ("")
Sun Icon (sun.max.fill)
Moon Icon (moon.fill)
The user can modify any cell in the grid with one of the three available icons.

3. **Row and Column Validity Check**

Every time an icon is changed, the game checks if the corresponding row or column is valid.
A row or column is valid if it contains exactly 3 icons of one type and 3 of another (with no empty icons).
Also there cannot be more than two adjacent icons with the same aspect in a row/column.
If a row or column is invalid, the icon color change to red, indicating an error.

4. **Win Condition**

Once all rows and columns are valid (i.e., each contains 3 icons of one type and 3 of another), the game announces the win with the message "You Win!".

5. **Timer**

A timer is displayed at the top of the screen, tracking the time elapsed since the game started.
The timer stops when the user wins, marking the end of the game.

6. **Button Disabling**

If a row or column is not valid, the corresponding buttons can be disabled to prevent further input until the user fixes the issue.
Getting Started

# Run the project:

Clone or download the repository.

Open the project in Xcode.

Build and run the project on a simulator or real device.
