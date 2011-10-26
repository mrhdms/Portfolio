package scene 
{
	import flash.events.Event;
	import jp.nium.utils.XMLUtil;
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
	import jp.progression.loader.*;
	import jp.progression.*;
	import jp.progression.scenes.*;
	
	/**
	 * プロフィールのシーン
	 * @author Hidemasa Mori
	 */
	public class ProfileScene extends SceneObject 
	{
		private var _prof:ProfilePage;
		
		/**
		 * 新しい ProfileScene インスタンスを作成します。
		 */
		public function ProfileScene( name:String = null, initObject:Object = null ) 
		{
			// 親クラスを初期化する
			super( name, initObject );
			
			_prof = new ProfilePage();
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void 
		{
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void 
		{
			
			var xmlData:XMLList = new XMLList(dataHolder.data);
			var obj:Object = XMLUtil.xmlToObject(xmlData);
			
			//シーンタイトル
			title = obj.title;
			
			//ちょいうごき
			CastDocument.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler)
			
			addCommand(
				new Prop(_prof, { x:300,y:124,alpha:0 } ),
				new AddChildAt(container, _prof, 20),
				new DoTweener(_prof,{alpha:1,time:0.5})
			);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			_prof.x += (((CastDocument.center - CastDocument.stage.mouseX) / 10 + 300) - _prof.x)/10;
			_prof.y += (((CastDocument.middle - CastDocument.stage.mouseY) / 10 + 124) - _prof.y)/10;
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void 
		{
			addCommand(
				new DoTweener(_prof, { alpha:0, time:0.5 } ),
				new RemoveChild(container, _prof)
			);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void 
		{
		}
	}
}