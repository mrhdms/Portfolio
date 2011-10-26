package  
{
	import asset.ClickSound;
	import asset.DotSound;
	import asset.DotSound2;
	
	/**
	 * ...
	 * @author Hidemasa Mori
	 * @date created 2011/10/18
	 */
	public class Singleton 
	{
		
		private static var instance:Singleton;
		
		public static function get getInstance():Singleton 
		{ 
			if(Singleton.instance == null)
			{ 
				Singleton.instance = new Singleton(arguments.callee);
			}
			return instance;
		} 
		
		public function Singleton(caller:Function = null) 
		{ 
			if(Singleton.instance != null) 
			{
				throw new Error("Singletonインスタンスはひとつしか生成できません。");
			} else if (caller == null) 
			{
				throw new Error("SingletonクラスはSingletonクラスです。getInstance()メソッドを使ってインスタンス化してください。");
			}
		}
		
		//ナビゲーションボタン情報の保持
		private var _naviInfo:Object = new Object();
		
		public function get naviInfo():Object 
		{
			return _naviInfo;
		}
		
		public function set naviInfo(value:Object):void 
		{
			_naviInfo = value;
		}
		
		//共有サウンドインスタンス
		private var _sound:DotSound = new DotSound();
		private var _sound2:DotSound2 = new DotSound2();
		private var _clickSound:ClickSound = new ClickSound();
		
		public function get sound():DotSound 
		{
			return _sound;
		}
		
		public function get sound2():DotSound2 
		{
			return _sound2;
		}
		
		public function get clickSound():ClickSound 
		{
			return _clickSound;
		}
	}
	
}