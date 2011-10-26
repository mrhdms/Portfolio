package  
{
	import asset.Title;
	import flash.display.Bitmap;
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
	import jp.progression.executors.*;
	import jp.progression.scenes.*;
	
	/**
	 * ...
	 * @author Hidemasa Mori
	 */
	public class IndexScene extends SceneObject 
	{
		
		/**
		 * 新しい IndexScene インスタンスを作成します。
		 */
		public function IndexScene() 
		{
			// シーンタイトルを設定します。
			title = "Hidemasa Mori - Portfolio";
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void 
		{
			var tweetView:TweetView = new TweetView();
			var nav:Navigation = new Navigation();
			var logo:Bitmap = new Bitmap(new Title());
			
			//Twitter用の処理リスト
			var sl:SerialList = new SerialList();
			sl.addCommand(
				new Listen(tweetView,"standby"),
				new Prop(tweetView,{x:310,y:34}),
				new AddChildAt(container, tweetView,0)
			);
			sl.execute();
			
			addCommand(
				new Prop(nav, { x:0, y:123 } ),
				new Prop(logo, { x:10, y:0, alpha:0 } ),
				new AddChildAt(container, nav,5),
				new AddChild(container, logo),
				new DoTweener(logo,{y:34,alpha:1,time:1,transition:TransitionUtil.easeOutExpo})
			);
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void 
		{
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void 
		{
			addCommand(
			);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void 
		{
			addCommand(
			);
		}
	}
}
