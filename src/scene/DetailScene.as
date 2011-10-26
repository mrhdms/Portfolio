package scene 
{
	import asset.Close;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
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
	 * ...
	 * @author Hidemasa Mori
	 */
	public class DetailScene extends SceneObject 
	{
		private var _detail:DetailBox;
		private var _closeCursole:Close;
		private var _white:Sprite;
		
		/**
		 * 新しい DetailScene インスタンスを作成します。
		 */
		public function DetailScene( name:String = null, initObject:Object = null ) 
		{
			// 親クラスを初期化する
			super( name, initObject );
			
			//バッテンカーソル用
			_closeCursole = new Close();
			_closeCursole.visible = false;
			_closeCursole.scaleX = _closeCursole.scaleY = 2;
			_closeCursole.addEventListener(MouseEvent.CLICK, closeCursole_clickHandler);
			
			//全画面下敷き
			_white = new Sprite();
			_white.graphics.beginFill(0xFFFFFF, 0.2);
			_white.graphics.drawRect(0, 0, 500, 500);
			_white.graphics.endFill();
			
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
			
			//下敷きサイズ設定
			CastDocument.stage.addEventListener(Event.RESIZE, white_resizeHandler);
			white_resizeHandler();
			
			_detail = new DetailBox();
			_detail.y = 305;
			
			addCommand(
				new AddChildAt(container, _white,10),
				new AddChildAt(container, _detail,11),
				new AddChildAt(container, _closeCursole,12),
				new Func(function():void { 
					_detail.addEventListener(Event.ENTER_FRAME, detail_enterFrameHandler)
					}
				)
			);
		}
		
		private function white_resizeHandler(e:Event = null):void 
		{
			//下敷きサイズ
			_white.width = CastDocument.stage.stageWidth;
			_white.height = CastDocument.stage.stageHeight;
		}
		
		private function detail_enterFrameHandler(e:Event):void 
		{
			//カーソル操作
			var target:DetailBox = e.currentTarget as DetailBox;
			if (target.hitTestPoint(CastDocument.stage.mouseX,CastDocument.stage.mouseY)) 
			{
				Mouse.show();
				_closeCursole.visible = false;
			} else {
				Mouse.hide();
				_closeCursole.visible = true;
				_closeCursole.x = CastDocument.stage.mouseX;
				_closeCursole.y = CastDocument.stage.mouseY;
			}
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void 
		{
			addCommand(
				new RemoveChild(container, _closeCursole),
				new RemoveChild(container, _white),
				new RemoveChild(container, _detail),
				CastDocument.stage.removeEventListener(Event.RESIZE, white_resizeHandler)
			);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void 
		{
		}
		
		/**
		 * 閉じる
		 * @param	e
		 */
		private function closeCursole_clickHandler(e:MouseEvent):void 
		{
			Singleton.getInstance.clickSound.play();
			manager.goto(manager.current.parent.sceneId);
			_detail.removeEventListener(Event.ENTER_FRAME, detail_enterFrameHandler);
			Mouse.show();
		}
	}
}