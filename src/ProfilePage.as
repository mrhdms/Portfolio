package  
{
	import asset.Profile;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import jp.iixx.mrhdms.util.DateUtil;
	import jp.progression.casts.*;
	import jp.progression.commands.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.data.*;
	import jp.progression.events.*;
	import jp.progression.scenes.*;
	
	/**
	 * プロフィールのページ
	 * @author Hidemasa Mori
	 */
	public class ProfilePage extends CastSprite 
	{
		private var _view:Profile;
		
		/**
		 * 新しい ProfilePage インスタンスを作成します。
		 */
		public function ProfilePage( initObject:Object = null ) 
		{
			// 親クラスを初期化します。
			super( initObject );
			
			_view = new Profile();
			
			//年齢表記
			var now:Date = new Date();
			var birth:Date = new Date(1983, 10, 3);
			var age:uint = uint(DateUtil.diffYear(birth, now));
			var date:uint = uint(DateUtil.diffDate(birth, now, true));
			_view.ageTxt.text = "（" + age.toString() + "歳と" + date.toString() + "日）";
			
			addChild(_view);
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastAdded():void 
		{
			_view.close.addEventListener(MouseEvent.CLICK, close_clickHandler);
			_view.close.addEventListener(MouseEvent.ROLL_OVER, close_rollOverHandler);
			_view.close.addEventListener(MouseEvent.ROLL_OUT, close_rollOutHandler);
			_view.close.buttonMode = true;
			
		}
		
		
		private function close_rollOverHandler(e:MouseEvent):void 
		{
			Tweener.addTween(e.currentTarget, { rotation:90, time:1 } );
			Singleton.getInstance.sound.play();
		}
		
		private function close_rollOutHandler(e:MouseEvent):void 
		{
			Tweener.addTween(e.currentTarget, { rotation:0, time:1 } );
		}
		
		private function close_clickHandler(e:MouseEvent):void 
		{
			manager.goto(new SceneId("/index/"));
			Singleton.getInstance.clickSound.play();
		}
		
		/**
		 * IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRemoved():void 
		{
			_view.close.removeEventListener(MouseEvent.CLICK, close_clickHandler);
			_view.close.removeEventListener(MouseEvent.ROLL_OVER, close_rollOverHandler);
			_view.close.removeEventListener(MouseEvent.ROLL_OUT, close_rollOutHandler);
			_view.close.buttonMode = false;
		}
	}
}