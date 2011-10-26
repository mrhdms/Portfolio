package  
{
	import asset.Nav;
	import caurina.transitions.Tweener;
	import flash.text.TextFormat;
	import jp.iixx.mrhdms.util.TransitionUtil;
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
	 * ナビゲーションボタン
	 * @author Hidemasa Mori
	 */
	public class NavButton extends CastButton 
	{
		private var _ui:Nav;
		
		//選択中かどうかのフラグ
		private var _isActive:Boolean = false;
		
		/**
		 * 新しい NavButton インスタンスを作成します。
		 */
		public function NavButton( initObject:Object/*link,name*/ = null ) 
		{
			// 親クラスを初期化します。
			super( initObject );
			
			var linkRegexp:RegExp = new RegExp("^http.*");
			if (linkRegexp.test(initObject.link)) 
			{
				// 外部リンクの場合には href プロパティに設定します。
				href = initObject.link;
			} else {
				// 移動先となるシーン識別子を設定します。
				sceneId = new SceneId( initObject.link );
			}
			
			_ui = new Nav();
			_ui.navTxt.text = initObject.name;
			var tf:TextFormat = _ui.navTxt.getTextFormat();
			tf.letterSpacing = 3;
			_ui.navTxt.setTextFormat(tf);
			addChild(_ui);
			
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastAdded():void 
		{
			Tweener.addTween(_ui.line, { scaleY:0, time:0.5, transition:TransitionUtil.easeOutExpo } );
			Tweener.addTween(_ui.bg, { scaleX:0, time:1, transition:TransitionUtil.easeOutExpo } );
			addCommand(
			)
		}
		
		/**
		 * IExecutable オブジェクトが RemoveChild コマンド、または RemoveAllChild コマンド経由で表示リストから削除された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRemoved():void 
		{
		}
		
		/**
		 * Flash Player ウィンドウの CastButton インスタンスの上でユーザーがポインティングデバイスのボタンを押すと送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastMouseDown():void 
		{
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastMouseUp():void 
		{
			Singleton.getInstance.clickSound.play();
		}
		
		/**
		 * ユーザーが CastButton インスタンスにポインティングデバイスを合わせたときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRollOver():void 
		{
			Singleton.getInstance.sound.play();
			//addCommand(
				//new DoTweener(_ui.bg,{scaleX:1,time:1,transition:TransitionUtil.easeOutExpo}),
				//new DoTweener(_ui.line,{scaleY:1,time:0.5,transition:TransitionUtil.easeOutExpo})
			//)
			Tweener.addTween(_ui.bg,{scaleX:1,time:1,transition:TransitionUtil.easeOutExpo});
			Tweener.addTween(_ui.line,{scaleY:1,time:0.5,transition:TransitionUtil.easeOutExpo});
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRollOut():void 
		{
			if (!_isActive) 
			{
				//addCommand(
					//new DoTweener(_ui.line,{scaleY:0,time:0.5,transition:TransitionUtil.easeOutExpo}),
					//new DoTweener(_ui.bg,{scaleX:0,time:1,transition:TransitionUtil.easeOutExpo},{scaleX:_ui.bg.scaleX})
				//)
				
				Tweener.addTween(_ui.bg,{scaleX:0,time:1,transition:TransitionUtil.easeOutExpo});
				Tweener.addTween(_ui.line,{scaleY:0,time:0.5,transition:TransitionUtil.easeOutExpo});
			}
		}
		
		public function get isActive():Boolean 
		{
			return _isActive;
		}
		
		public function set isActive(value:Boolean):void 
		{
			_isActive = value;
			this.mouseEnabled = false;
			
			if (!_isActive) 
			{
				this.mouseEnabled = true;
				Tweener.addTween(_ui.bg,{scaleX:0,time:1,transition:TransitionUtil.easeOutExpo});
				Tweener.addTween(_ui.line,{scaleY:0,time:0.5,transition:TransitionUtil.easeOutExpo});
			}
		}
	}
}