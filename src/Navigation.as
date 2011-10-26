package  
{
	import jp.progression.casts.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.commands.*;
	import jp.progression.data.*;
	import jp.progression.events.*;
	import jp.progression.scenes.*;
	
	/**
	 * ナビボタン配置
	 * @author Hidemasa Mori
	 */
	public class Navigation extends CastSprite 
	{
		private var _navName:Array = ["PROFILE","WORKS","LAB","BLOG"];
		private var _navLink:Array = ["/index/profile", "/index/works", "/index/lab", "http://mrhdms.iixx.jp/"];
		private var _navAry:Array = [];
		
		/**
		 * 新しい Navigation インスタンスを作成します。
		 */
		public function Navigation( initObject:Object = null ) 
		{
			// 親クラスを初期化します。
			super( initObject );
			
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastAdded():void 
		{
			//遷移状態を監視
			manager.addEventListener(ProcessEvent.PROCESS_START, manager_processStartHandler);
			manager.addEventListener(ProcessEvent.PROCESS_CHANGE, manager_processStartHandler);
			
			//ナビゲーションボタンを生成
			var tl:TweenList = new TweenList(0.2);
			for (var i:int = 0; i < 4; i++) 
			{
				var btn:NavButton = new NavButton( { name:_navName[i], link:_navLink[i] } );
				btn.y = 60 * i;
				tl.addCommand(
					new AddChild(this,btn)
				);
				//ボタンの情報を登録しておく
				Singleton.getInstance.naviInfo[_navLink[i]] = { name:_navName[i], rect:btn.getRect(this.parent.parent) };
				//ボタンインスタンスを配列に追加
				_navAry.push(btn);
			}
			addCommand(tl);
		}
		
		private function manager_processStartHandler(e:ProcessEvent):void 
		{
			var len:uint = _navAry.length;
			for (var i:int = 0; i < len; i++) 
			{
				var reg:RegExp = new RegExp("^" + _navLink[i] + ".*");
				if (reg.test(manager.destinedSceneId.toString())) 
				{
					_navAry[i].isActive = true;
				} else {
					_navAry[i].isActive = false;
				}
			}
		}
		
		/**
		 * IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRemoved():void 
		{
		}
	}
}