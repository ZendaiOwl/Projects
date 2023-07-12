/* StringCharacterIterator.java -- Iterate over a character range in a string
   Copyright (C) 1998, 1999 Free Software Foundation, Inc.

This file is part of GNU Classpath.

GNU Classpath is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.
 
GNU Classpath is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Classpath; see the file COPYING.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
02111-1307 USA.

As a special exception, if you link this library with other files to
produce an executable, this library does not by itself cause the
resulting executable to be covered by the GNU General Public License.
This exception does not however invalidate any other reasons why the
executable file might be covered by the GNU General Public License. */


package java.text;

/**
  * This class iterates over a range of characters in a <code>String</code>.  
  * For a given range of text, a beginning and ending index,
  * as well as a current index are defined.  These values can be queried
  * by the methods in this interface.  Additionally, various methods allow
  * the index to be set. 
  *
  * @version 0.0
  *
  * @author Aaron M. Renn (arenn@urbanophile.com)
  */
public final class StringCharacterIterator implements CharacterIterator
{

/*************************************************************************/

/*
 * Instance Variables
 */

/**
  * This is the string to iterate over
  */
private String text;

/**
  * This is the value of the start position of the text range.
  */
private int begin;

/**
  * This is the value of the ending position of the text range.
  */
private int end;

/**
  * This is the current value of the scan index.
  */
private int index;

/*************************************************************************/

/*
 * Constructors
 */

/**
  * This method initializes a new instance of <code>StringCharacterIterator</code>
  * to iterate over the entire text of the specified <code>String</code>.  The
  * initial index value will be set to the first character in the string.
  *
  * @param text The <code>String</code> to iterate through.
  */
public
StringCharacterIterator(String text)
{
  this(text, 0, text.length(), 0);
}

/*************************************************************************/

/**
  * This method initializes a new instance of <code>StringCharacterIterator</code>
  * to iterate over the entire text of the specified <code>String</code>.  The
  * initial index value will be set to the specified value.
  *
  * @param text The <code>String</code> to iterate through.
  * @param index The initial index position.
  */
public
StringCharacterIterator(String text, int index)
{
  this(text, 0, text.length(), index);
}

/*************************************************************************/

/**
  * This method initializes a new instance of <code>StringCharacterIterator</code>
  * that iterates over the text in a subrange of the specified 
  * <code>String</code>.  The beginning and end of the range are specified
  * by the caller, as is the initial index position.
  *
  * @param text The <code>String</code> to iterate through.
  * @param begin The beginning position in the character range.
  * @param end The ending position in the character range.
  * @param index The initial index position.
  *
  * @param IllegalArgumentException If any of the range values are invalid.
  */
public
StringCharacterIterator(String text, int begin, int end, int index)
{
  int len = text.length();

  if (len == 0)
    {
      if ((begin != 0) || (end != 0) || (index != 0))
        throw new IllegalArgumentException("Bad parameters");
    }
  else
    {
      if ((begin < 0) || (begin > len))
        throw new IllegalArgumentException("Bad begin position");

      if ((end < begin) || (end > len))
        throw new IllegalArgumentException("Bad end position");

      if ((index < begin) || (index > end))
        throw new IllegalArgumentException("Bad initial index position");
    }

  this.text = text;
  this.begin = begin;
  this.end = end;
  this.index = index;
}

/*************************************************************************/

/**
  * This is a package level constructor that copies the text out of
  * an existing StringCharacterIterator and resets the beginning and
  * ending index.
  *
  * @param scci The StringCharacterIterator to copy the info from
  * @param begin The beginning index of the range we are interested in.
  * @param end The ending index of the range we are interested in.
  */
StringCharacterIterator(StringCharacterIterator sci, int begin, int end)
{
  this(sci.text, begin, end, begin);
}

/*************************************************************************/

/*
 * Instance Methods
 */

/**
  * This method returns the character at the current index position
  *
  * @return The character at the current index position.
  */
public char
current()
{
  if (getIndex() == getEndIndex())
    return(DONE);

  return(text.charAt(getIndex()));
}

/*************************************************************************/

/**
  * This method increments the current index and then returns the character
  * at the new index value.  If the index is already at <code>getEndIndex() - 1</code>,
  * it will not be incremented.
  *
  * @return The character at the position of the incremented index value, or <code>DONE</code> if the index has reached getEndIndex() - 1
  */
public char
next()
{
  if (getIndex() == getEndIndex())
    return(DONE);

  ++index;
  return(current());
}

/*************************************************************************/

/**
  * This method decrements the current index and then returns the character
  * at the new index value.  If the index value is already at the beginning
  * index, it will not be decremented.
  *
  * @return The character at the position of the decremented index value, or <code>DONE</code> if index was already equal to the beginning index value.
  */
public char
previous()
{
  if (getIndex() == getBeginIndex())
    return(DONE);

  --index;
  return(current());
}

/*************************************************************************/

/**
  * This method sets the index value to the beginning of the range and returns
  * the character there.
  *
  * @return The character at the beginning of the range, or <code>DONE</code> if the range is empty.
  */
public char
first()
{
  index = getBeginIndex();
  return(current());
}

/*************************************************************************/

/**
  * This method sets the index value to <code>getEndIndex() - 1</code> and
  * returns the character there.  If the range is empty, then the index value
  * will be set equal to the beginning index.
  *
  * @return The character at the end of the range, or <code>DONE</code> if the range is empty.
  */
public char
last()
{
  if (getEndIndex() == getBeginIndex())
    return(DONE);

  index = getEndIndex() - 1;
  return(current());
}

/*************************************************************************/

/**
  * This method returns the current value of the index.
  *
  * @return The current index value
  */
public int
getIndex()
{
  return(index);
}

/*************************************************************************/

/**
  * This method sets the value of the index to the specified value, then
  * returns the character at that position.
  *
  * @param index The new index value.
  *
  * @return The character at the new index value or <code>DONE</code> if the index value is equal to <code>getEndIndex</code>.
  *
  * @exception IllegalArgumentException If the specified index is not valid
  */
public char
setIndex(int index)
{
  if ((index < begin) || (index > end))
    throw new IllegalArgumentException("Bad index specified");

  this.index = index;
  return(current());
}

/*************************************************************************/

/**
  * This method returns the character position of the first character in the
  * range.
  *
  * @return The index of the first character in the range.
  */
public int
getBeginIndex()
{
  return(begin);
}

/*************************************************************************/

/**
  * This method returns the character position of the end of the text range.
  * This will actually be the index of the first character following the
  * end of the range.  In the event the text range is empty, this will be
  * equal to the first character in the range.
  *
  * @return The index of the end of the range.
  */
public int
getEndIndex()
{
  return(end);
}

/*************************************************************************/

/**
  * This method creates a copy of this <code>CharacterIterator</code>.
  *
  * @return A copy of this <code>CharacterIterator</code>.
  */
public Object
clone()
{
  return(new StringCharacterIterator(text, begin, end, index));
}

/*************************************************************************/

/**
  * This method tests this object for equality againt the specified 
  * object.  This will be true if and only if the specified object:
  * <p>
  * <ul>
  * <li>is not <code>null</code>.
  * <li>is an instance of <code>StringCharacterIterator</code>
  * <li>has the same text as this object
  * <li>has the same beginning, ending, and current index as this object.
  * </ul>
  *
  * @param obj The object to test for equality against.
  *
  * @return <code>true</code> if the specified object is equal to this
  * object, <code>false</code> otherwise.
  */
public boolean
equals(Object obj)
{
  if (obj == null)
    return(false);

  if (!(obj instanceof StringCharacterIterator))
    return(false);

  StringCharacterIterator sci = (StringCharacterIterator)obj;

  if (!sci.text.equals(this.text))
    return(false);

  if (sci.begin != this.begin)
    return(false);

  if (sci.end != this.end)
    return(false);

  if (sci.index != this.index)
    return(false);

  return(true);
}

/*************************************************************************/

/**
  * This method allows other classes in java.text to change the value
  * of the underlying text being iterated through.
  *
  * @param text The new <code>String</code> to iterate through.
  */
void
setText(String text)
{
  this.text = text;
}

} // interface CharacterIterator

