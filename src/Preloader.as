package  
{
	import asset.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import jp.iixx.mrhdms.util.*;
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
	import jp.progression.executors.*;
	
	/**
	 * ...
	 * @author Hidemasa Mori
	 */
	public class Preloader extends CastPreloader 
	{
		private var _bg:Bitmap;
		private var _timer:Timer;
		private var _tf:TextField;
		private var _logo:Bitmap;
		private var _maskSp:Sprite;
		
		/**
		 * 新しい Preloader インスタンスを作成します。
		 */
		public function Preloader() 
		{
			// プリローダーが読み込むファイルと、実行形式を指定します。
			super( new URLRequest( "index.swf" ), false, CommandExecutor );
		}
		
		/**
		 * SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に送出されます。
		 */
		override protected function atReady():void 
		{
			//stageの初期化設定を行います。
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//背景
			_bg = new Bitmap(new Bg(), "auto", true);
			
			//ロゴ
			_logo = new Bitmap(new Title());
			_logo.x = CastDocument.center - _logo.width / 2;
			_logo.y = CastDocument.middle - _logo.height / 2;
			
			//ロゴマスク
			_maskSp = new Sprite();
			_maskSp.x = _logo.x;
			_maskSp.y = _logo.y + _logo.height;
			_maskSp.graphics.beginFill(0xFFFFFF);
			_maskSp.graphics.drawRect(0, -_logo.height, _logo.width, _logo.height);
			
			//イベントハンドラ設定
			stage.addEventListener(Event.RESIZE, stage_resizeHandler)
			stage_resizeHandler();
			//プログレスバー用タイマー
			_timer = new Timer(1000/60);
			_timer.addEventListener(TimerEvent.TIMER, loop);
			
			//テキスト
			_tf = new TextField();
			_tf.textColor = 0xFFFFFF;
			
		}
		
		/**
		 * プログレスバーアニメーション用ループ処理
		 * @param	e
		 */
		private function loop(e:TimerEvent):void 
		{
			//var per:Number = bytesLoaded / bytesTotal;
			var per:Number = _timer.currentCount / 3000;
			_maskSp.scaleY += (0 - per / _maskSp.scaleY) / 10;
			if (_maskSp.scaleY < 0.01) 
				{
					_maskSp.scaleY = 0;
					e.target.stop();
					e.target.removeEventListener(TimerEvent.TIMER, loop);
					dispatchEvent(new Event("comp"));
				}
		}
		
		
		
		/**
		 * オブジェクトが読み込みを開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastLoadStart():void 
		{
			addCommand(
				new AddChild(background, _bg),
				new AddChild(background, _logo),
				new AddChild(background, _maskSp),
				_timer.start()
			);
		}
		
		/**
		 * ダウンロード処理を実行中にデータを受信したときに送出されます。
		 */
		override protected function atProgress():void 
		{
		}
		
		/**
		 * オブジェクトが読み込みを完了した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastLoadComplete():void 
		{
			addCommand(
				new Listen(this,"comp"),
				new DoTweener(_logo,{y:_logo.y+100,time:0.5,alpha:0,transition:TransitionUtil.easeInExpo}),
				new RemoveChild(background, _logo),
				new RemoveChild(background, _maskSp)
			);
		}
		
		/**
		 * リサイズイベントハンドラ
		 * @param	e
		 */
		private function stage_resizeHandler(e:Event = null):void 
		{
			_bg.scaleX = _bg.scaleY = NumUtil.scaleRatioByShortSide(_bg.bitmapData.width, _bg.bitmapData.height, CastDocument.right, CastDocument.bottom);
			
			_logo.x = CastDocument.center - _logo.width / 2;
			_logo.y = CastDocument.middle - _logo.height / 2;
			_maskSp.x = _logo.x;
			_maskSp.y = _logo.y + _logo.height;
		}
	}	
}
