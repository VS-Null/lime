package lime._internal.macros;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;

class DefineMacro
{
	public static function run():Void
	{
		if (!Context.defined("tools"))
		{
			if (Context.defined("flash"))
			{
				if (Context.defined("air"))
				{
					var childPath = Context.resolvePath("lime/_internal");

					var parts = StringTools.replace(childPath, "\\", "/").split("/");
					parts.pop(); // lime
					parts.pop(); // src
					parts.pop(); // root directory

					var externPath = parts.join("/") + "/externs/air";

					Compiler.addClassPath(externPath);
				}
			}
			else if (Context.defined("js"))
			{
				if (!Context.defined("nodejs"))
				{
					Compiler.define("html5");
					Compiler.define("web");
					Compiler.define("lime-canvas");
					Compiler.define("lime-dom");
					Compiler.define("lime-howlerjs");
					Compiler.define("lime-webgl");
				}
			}
			else
			{
				Compiler.define("native");

				var cffi = (!Context.defined("nocffi") && !Context.defined("eval"));

				if (Context.defined("ios") || Context.defined("android") || Context.defined("tizen"))
				{
					Compiler.define("mobile");
					if (cffi) Compiler.define("lime-opengles");
				}
				else if (Context.defined("webassembly") || Context.defined("wasm") || Context.defined("emscripten"))
				{
					Compiler.define("webassembly");
					Compiler.define("wasm");
					Compiler.define("emscripten");
					Compiler.define("web");
					if (cffi) Compiler.define("lime-opengles");
				}
				else
				{
					Compiler.define("desktop");
					if (cffi) Compiler.define("lime-opengl");
				}

				if (cffi)
				{
					Compiler.define("lime-cffi");

					Compiler.define("lime-openal");
					Compiler.define("lime-cairo");
					Compiler.define("lime-curl");
					Compiler.define("lime-harfbuzz");
					Compiler.define("lime-vorbis");
				}
				else
				{
					Compiler.define("disable-cffi");
				}
			}
		}

		if (Context.defined("android") && Context.defined("extension-androidtools"))
			Context.fatalError('You cannot add extension-androidtools to this Lime because it is already included. Please remove it from project file.', (macro null).pos);
	}
}
#end
