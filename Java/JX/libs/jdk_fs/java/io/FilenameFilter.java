/* FilenameFilter.java -- Filter a list of filenames
   Copyright (C) 1998 Free Software Foundation, Inc.

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


package java.io;

/**
  * This interface has one method which is used for filtering filenames
  * returned in a directory listing.  It is currently used by the 
  * <code>File.list()</code> method and by the filename dialog in AWT.
  * <p>
  * The method in this interface determines if a particular file should
  * or should not be included in the file listing.
  *
  * @version 0.0
  *
  * @author Aaron M. Renn (arenn@urbanophile.com)
  */
public abstract interface FilenameFilter
{

/**
  * This method determines whether or not a given file should be included
  * in a directory listing.
  *
  * @param dir The <code>File</code> instance for the directory being read
  * @param name The name of the file to test
  *
  * @return <code>true</code> if the file should be included in the list, <code>false</code> otherwise.
  */
public abstract boolean
accept(File dir, String name);

} // interface FilenameFilter

