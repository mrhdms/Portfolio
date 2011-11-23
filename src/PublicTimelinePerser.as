package  
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * Twitterのパブリックタイムラインを取得してごにょるクラス
	 * @author Hidemasa Mori
	 * @date created 2011/10/14
	 */
	public class PublicTimelinePerser extends EventDispatcher
	{
		private var _tweetXML:XMLList;
		private var _tweetAry:Array = [];
		private var _timeAry:Array = [];
		
		public function PublicTimelinePerser(apiUrl:String) 
		{
			var loader:URLLoader;
			try 
			{
				loader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, loader_completeHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioErrorHandler)
				loader.load(new URLRequest(apiUrl));
			} catch (err:Error){
				trace("Twitter タイムライン取得時にエラーがおこりました。 "+ err.message);
			}
			
		}
		
		private function loader_ioErrorHandler(e:IOErrorEvent):void 
		{
			trace("Twitter のタイムラインを取得できませんでした。[IO Error]");
		}
		
		private function loader_completeHandler(e:Event):void 
		{
			_tweetXML = XMLList(e.currentTarget.data);
			
			//あらかじめツイート内容と時間は配列にいれておく
			for each (var item:XML in _tweetXML.*) 
			{
				_tweetAry.push(item.text.toString());
				_timeAry.push(item.created_at.toString());
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * ツイート内容を返す
		 * @param num num番目のツイート（0～）
		 */
		public function getTweetText(num:uint):String
		{
			 if (_tweetAry[num]) 
			 {
				 return _tweetAry[num];
			 } else {
				 return "";
			 }
		}
		
		/**
		 * ツイート時間を返す（○分前の表記）
		 * @param num num番目のツイート
		 */
		public function getTweetTimeDiff(num:uint):String
		{
			var now:Date = new Date();
			var postTime:Date = new Date();
			postTime.setTime(Date.parse(_timeAry[num]));
			var diff:Number =  now.getTime() - postTime.getTime();
			
			var sec:uint = uint(diff / 1000);
			var min:uint = uint(sec / 60);
			var hour:uint = uint(min / 60);
			var day:uint = uint(hour / 24);
			
			if (sec < 60) 
			{
				return sec + "秒前";
			} else if (min < 60) {
				return min + "分前";
			} else if (hour < 24) {
				return hour + "時間前";
			} else if (day < 31) {
				return day + "日前";
			} else {
				return postTime.getFullYear().toString() + "年 " + (postTime.getMonth() + 1).toString() + "月 " + postTime.getDate().toString() + "日"; 
			}
		}
	}

}