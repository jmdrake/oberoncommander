# Oberon Commander
An extension to the Oberon System which allows for easier writing of scripting tools.

Oberon is both a programming language and an operating system written by Nicholas Wirth, the inventor of Pascal and Modula-2.  Oberon's user interface is a document oriented user interface.  It falls somewhere in between a traditional command line interface like the Unix or DOS shells and GUI interfaces like Windows, Mac and X11.  Using it has the feel of Smalltalk/Squeak or ATT's Plan 9.

Out of the box there are command tools that allow users too run commands by clicking with the middle mouse button on Module.Procedure commands, taking parameters either after the command, from currently selected text, or from a marked viewer.

For examples:

Count.Lines SortDemo.Mod ~
Count.Lines *
Count.Lines ^

The first takes the argument "SortDemo.Mod" right from after the command that is clicked.  The ~ marks the end of the command parameters list.

The second runs Count.Lines against whatever document is marked with a * .  F1 is used to set that. 

The third runs Count.Lines against a file name currently selected.

While this is conceptually simple to run, it's a bit cumbersome to implement, at least until now.  Commander.Mod extends Oberon so that it's easy to write new programs that use the ~, ^, ^ commannd input convention.  Also it makes it possible to write your own scanner.  The scanner that comes with Texts is specific to scanning for Oberon syntax.  The default Commander scanner scans for whitespace but it can easily be extended. 

Connections is a sample application that uses Commander.  Actually it's the reason I wrote commander in the first place.  It takes a list of TCP hosts and checks to see if they are alive.  The "quiet" option shows only those that are alive.  ConnectionTask is a non-blocking version of the same program that makes use of Oberon's single process multitasking.

Connections.Test *
Connections.Test HOST1 HOST2 HOST3 ~
Connections.Test ^
Connections.SetOptions quiet ~
Connections.SetOptions verbose ~

ConnectionTask.SetOptions quiet ~
ConnectionTask.SetOptions verbose ~

ConnectionTask.Test *
ConnectionsTask.Test HOST1 HOST2 HOST3 ~
ConnectionsTask.Test ^

I have initially written this for Oberon V4, but I have taken care to make it as portable as possible.  I believe it can easily be ported to Oberon System 3, Active Oberon and BlackBox Component Pascal.
