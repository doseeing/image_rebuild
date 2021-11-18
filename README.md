# image_rebuild
For demonstrate image rebuild problem

## Problem
Image in listview will rebuild when navigator push and pop pages

## How to reproduce
1. add debug log in Image widget build function
2. start this project, click listview item
  you will see every image in listview item call build function
3. pop from blank page
  you will see every image in list view item call build function

## What is wrong
In common sence, image widget should not be rebuilt whenever data changed

## What to expect
Image widget only build once when they show.

## Flutter Issue related to this

https://github.com/flutter/flutter/issues/11655