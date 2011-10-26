package  
{
	import asset.Detail;
	import asset.SubImage;
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import jp.iixx.mrhdms.util.TransitionUtil;
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
	import jp.progression.scenes.*;
	
	/**
	 * ...
	 * @author Hidemasa Mori
	 */
	public class DetailBox extends CastSprite 
	{
		private var _ui:Detail;
		private var _len:uint;
		private var _imgWrap:Sprite;
		private var _imgWrapMask:Sprite;
		
		/**
		 * 新しい DetailBox インスタンスを作成します。
		 */
		public function DetailBox( initObject:Object = null ) 
		{
			// 親クラスを初期化します。
			super( initObject );
			
			_ui = new Detail();
			_ui.caption_bg.scaleY = 0;
			_ui.captionTxt.visible = false;
			_ui.detail_bg.width = 0;
			_ui.launchiBtn.visible = false;
			addChild(_ui);
			
			//イメージ内包用
			_imgWrap = new Sprite();
			_imgWrapMask = new Sprite();
			_imgWrap.mask = _imgWrapMask;
			_ui.addChild(_imgWrap);
			_ui.addChild(_imgWrapMask);
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastAdded():void 
		{
			var dataXML:XMLList = XMLList(manager.current.dataHolder.data);
			var obj:Object = XMLUtil.xmlToObject(dataXML);
			_len = dataXML.imagePath.length();
			
			//画像マスク領域確保
			_imgWrapMask.graphics.beginFill(0);
			_imgWrapMask.graphics.drawRect(0, 0, 260 + (290 * _len) + 20, 305);
			
			//外部画像読み込み
			var ll:LoaderList = new LoaderList();
			for (var i:int = 0; i < _len; i++) 
			{
				ll.addCommand(new LoadSWF(new URLRequest(dataXML.imagePath[i].toString()), new CastLoader()));
			}
			
			//テキスト挿入
			_ui.captionTxt.text = obj.caption.toString();
			
			//追加時アニメーション
			var tl:TweenList = new TweenList(0.2);
			var targetWidth:Number = 260 + (290 * _len) + 20;
			
			trace(targetWidth);
			tl.addCommand(
				new DoTweener(_ui.caption_bg, { scaleY:1, time:1, transition:TransitionUtil.easeOutExpo } ),
				new Func( function():void { 
					if (CastDocument.stage.stageWidth > 260 + (290 * _len) + 20) 
					{
						targetWidth = CastDocument.stage.stageWidth;
					}
					
					Tweener.addTween(_ui.detail_bg, { width:targetWidth, time:1, transition:TransitionUtil.easeOutExpo } );
				} ),
				new Func(function():void { _ui.captionTxt.visible = true; })
			);
			
			//リサイズイベント登録、実行
			CastDocument.stage.addEventListener(Event.RESIZE, stage_resizeHandler);
			stage_resizeHandler();
			
			addCommand(
				tl,
				new Func(function():void {
						//外部リンクボタン
						if (obj.launchPath) 
						{
							_ui.launchiBtn.visible = true;
							_ui.launchiBtn.buttonMode = true;
							_ui.launchiBtn.url = obj.launchPath.toString();
							_ui.launchiBtn.addEventListener(MouseEvent.CLICK, launchiBtn_clickHandler);
							_ui.launchiBtn.addEventListener(MouseEvent.ROLL_OVER, launchiBtn_rollOverHandler);
							_ui.launchiBtn.addEventListener(MouseEvent.ROLL_OUT, launchiBtn_rollOutHandler);
						}
					
						//画像下敷き配置
						for (i = 0; i < _len; i++) 
						{
							var subImg:Bitmap = new Bitmap(new SubImage());
							subImg.x = 260 + 290 * i;
							subImg.y = 18;
							subImg.alpha = 0;
							_imgWrap.addChild(subImg);
							Tweener.addTween(subImg, { alpha:1, time:0.5, delay:i * 0.2 } );
						}
					}),
				ll,
				new Func(function():void {
					for (i = 0; i < _len; i++) 
					{
						var img:CastLoader = getResourceById(dataXML.imagePath[i].toString()).data as CastLoader;
						img.x = 260 + 290 * i;
						img.y = 18;
						img.alpha = 0;
						_imgWrap.addChild(img);
						Tweener.addTween(img, { alpha:1, time:0.5, delay:i * 0.2 } );
					}
				}),
				new Func(function(detail:DetailBox):void {
					if (CastDocument.stage.stageWidth < detail.width) {
						CastDocument.stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
					}
				},[this])
			);
		}
		
		private function launchiBtn_rollOverHandler(e:MouseEvent):void 
		{
			e.currentTarget.gotoAndStop(2);
			Singleton.getInstance.sound.play();
		}
		
		private function launchiBtn_rollOutHandler(e:MouseEvent):void 
		{
			e.currentTarget.gotoAndStop(1);
		}
		
		private function launchiBtn_clickHandler(e:MouseEvent):void 
		{
			navigateToURL(new URLRequest(e.currentTarget.url));
			Singleton.getInstance.clickSound.play();
		}
		
		private function stage_resizeHandler(e:Event = null):void 
		{
			//TODO リサイズしたときに右端がみえてまうのを直す
			if (CastDocument.stage.stageWidth > 260 + (290 * _len) + 20) {
				Tweener.addTween(_ui.detail_bg,{width:CastDocument.stage.stageWidth,time:0.5});
			}
		}
		
		private function stage_enterFrameHandler(e:Event):void 
		{
			this.x += ((CastDocument.stage.mouseX / CastDocument.stage.stageWidth  * (CastDocument.stage.stageWidth - this.width)) - this.x)/5;
		}
		
		/**
		 * IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRemoved():void 
		{
			CastDocument.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
			if(CastDocument.stage.hasEventListener(Event.ENTER_FRAME)) CastDocument.stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler)
			
			var tl:TweenList = new TweenList(0.2);
			tl.addCommand(
				new Func(function():void { 
					_ui.captionTxt.visible = false; 
					_ui.launchiBtn.visible = false;
					
					_ui.launchiBtn.removeEventListener(MouseEvent.CLICK, launchiBtn_clickHandler);
					_ui.launchiBtn.removeEventListener(MouseEvent.ROLL_OVER, launchiBtn_rollOverHandler);
					_ui.launchiBtn.removeEventListener(MouseEvent.ROLL_OUT, launchiBtn_rollOutHandler);
				}),
				new DoTweener(_imgWrapMask, { scaleX:0, time:1, transition:TransitionUtil.easeOutExpo } ),
				new DoTweener(_ui.detail_bg, { scaleX:0, time:1, transition:TransitionUtil.easeOutExpo } ),
				new DoTweener(_ui.caption_bg, { scaleX:0, time:1, transition:TransitionUtil.easeOutExpo } )
			);
			
			
			addCommand(
				tl
			);
			
		}
	}
}