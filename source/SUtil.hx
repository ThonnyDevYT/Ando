package;

#if android
//import android.AndroidTools;
import android.Permissions;
#end
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;

class SUtil
{
    #if android
    private static var aDir:String = null;
    //private static var sPath:String = AndroidTools.getExternalStorageDirectory();  
    //private static var grantedPermsList:Array<Permissions> = AndroidTools.getGrantedPermissions();  
    #end

    static public function getPath():String
    {
        #if android
        if (aDir != null && aDir.length > 0) 
        {
            return aDir;
        } 
        return aDir;
        #else
        return "";
        #end
    }

    static public function doTheCheck()
    {
        #if android

        if (!FileSystem.exists(SUtil.getPath() + "log")){
            FileSystem.createDirectory(SUtil.getPath() + "log");
        }

        if (!FileSystem.exists(SUtil.getPath() + "system-saves")){
            FileSystem.createDirectory(SUtil.getPath() + "system-saves");
        }

        if (!FileSystem.exists(SUtil.getPath() + "assets")){
            SUtil.applicationAlert("Instructions:", "You have to copy assets/assets from apk to your internal storage app directory " + "( here " + SUtil.getPath() + " )" + "if you hadn't have Zarhiver Downloaded, download it and enable the show hidden files option to have the folder visible" + "\n" + "Press Ok To Close The App");
            flash.system.System.exit(0);
        }
        
        if (!FileSystem.exists(SUtil.getPath() + "mods")){
            SUtil.applicationAlert("Instructions:", "You have to copy assets/mods from apk to your internal storage app directory " + "( here " + SUtil.getPath() + " )" + "if you hadn't have Zarhiver Downloaded, download it and enable the show hidden files option to have the folder visible" + "\n" + "Press Ok To Close The App");
            flash.system.System.exit(0);
        }
        #end
    }

    //Thanks Forever Engine
    static public function gameCrashCheck(){
        Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
    }
     
    static public function onCrash(e:UncaughtErrorEvent):Void {
        var callStack:Array<StackItem> = CallStack.exceptionStack(true);
        var dateNow:String = Date.now().toString();
        dateNow = StringTools.replace(dateNow, " ", "_");
        dateNow = StringTools.replace(dateNow, ":", "'");
        var path:String = "log/" + "crash_" + dateNow + ".txt";
        var errMsg:String = "";

        for (stackItem in callStack)
        {
            switch (stackItem)
            {
                case FilePos(s, file, line, column):
                    errMsg += file + " (line " + line + ")\n";
                default:
                    Sys.println(stackItem);
            }
        }

        errMsg += e.error;

        if (!FileSystem.exists(SUtil.getPath() + "log")){
            FileSystem.createDirectory(SUtil.getPath() + "log");
        }

        sys.io.File.saveContent(SUtil.getPath() + path, errMsg + "\n");
        
        Sys.println(errMsg);
        Sys.println("Crash dump saved in " + Path.normalize(path));
        Sys.println("Making a simple alert ...");

        SUtil.applicationAlert("Uncaught Error:", errMsg);
        flash.system.System.exit(0);
    }
    
    public static function applicationAlert(title:String, description:String){
        Application.current.window.alert(description, title);
    }

    static public function saveContent(fileName:String = "file", fileExtension:String = ".json", fileData:String = "you forgot something to add in your code"){
        if (!FileSystem.exists(SUtil.getPath() + "system-saves")){
            FileSystem.createDirectory(SUtil.getPath() + "system-saves");
        }

        sys.io.File.saveContent(SUtil.getPath() + "system-saves/" + fileName + fileExtension, fileData);
        #if android
        AndroidTools.makeToast("File Saved Successfully!");
        #end
    }
}
