
/**
 * Copyright 2022 Victor-ray, S. <victorray91@pm.me>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the Software), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
class Log {
  private static Logger log;
  private static final String err = "Usage: java Log [Log level] Log message ... \nLog levels: Debug: -1, Info: 0, Warning: 1, Error: 2";
  private static final int DEBUG = -1, INFO = 0, WARN = 1, ERROR = 2;
  public static void main(String[] args) {
    log = initLogger();
    log.setLevel(Level.ALL);
    int Lv = Integer.parseInt(args[0]);
    String message = "";
    for (String s: Arrays.copyOfRange(args, WARN, args.length)) { message+=s + " "; }
    if (Lv == DEBUG) { Debug(message); }
    else if (Lv == INFO) { Info(message); }
    else if (Lv == WARN) { Warning(message); }
    else if (Lv == ERROR) { Error(message); }
    else { Error(err); }
  }
  private static Logger initLogger() { return Logger.getAnonymousLogger(); }
  private static void Debug(String msg) { log.log(Level.OFF, msg); }
  private static void Info(String msg) { log.info(msg); }
  private static void Warning(String msg) { log.warning(msg); }
  private static void Error(String msg) { log.log(Level.SEVERE,msg); }
}
