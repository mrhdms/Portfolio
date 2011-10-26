package  
{
	import asset.Tweet;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
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
	 * ツイートを表示するやつ
	 * @author Hidemasa Mori
	 */
	public class TweetView extends CastSprite 
	{
		private var _dispAry:Array =[];
		private var _getTweetCount:uint;
		
		/**
		 * 新しい TweetView インスタンスを作成します。
		 */
		public function TweetView( initObject:Object = null ) 
		{
			// 親クラスを初期化します。
			super( initObject );
			
			_getTweetCount = 10;
			
			var TweetData:PublicTimelinePerser = new PublicTimelinePerser("http://mrhdms.iixx.jp/Portforio/crossdomain-proxy.php?url=http://twitter.com/statuses/user_timeline/mrhdms.xml");
			TweetData.addEventListener(Event.COMPLETE, TweetData_completeHandler);
		}
		
		private function TweetData_completeHandler(e:Event):void 
		{
			var h:Number = 0;
			for (var i:int = 0; i < _getTweetCount; i++) 
			{
				var sp:Tweet = new Tweet();
				sp.y = h;
				
				sp.body.bodyTf.autoSize = TextFieldAutoSize.LEFT;
				sp.body.bodyTf.wordWrap = true;
				sp.body.bodyTf.mouseWheelEnabled = false;
				
				sp.body.bodyTf.text = PublicTimelinePerser(e.currentTarget).getTweetText(i);
				sp.time.timeTf.text = PublicTimelinePerser(e.currentTarget).getTweetTimeDiff(i);
				
				sp.time.y = sp.body.bodyTf.textHeight + 20;
				sp.line.y = sp.time.y + sp.time.timeTf.textHeight + 20;
				
				h += sp.line.y + 20;
				sp.alpha = 0;
				_dispAry.push(sp);
			}
			
			dispatchEvent(new Event("standby"));
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastAdded():void 
		{
			for (var i:int = 0; i < _getTweetCount; i++) 
			{
				addCommand(
					new AddChild(this,_dispAry[i]),
					new DoTweener(_dispAry[i], { alpha:1, time:1 } )
				)
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