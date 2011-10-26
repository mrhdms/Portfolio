package  
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import jp.progression.casts.*;
	import jp.progression.commands.*;
	import jp.progression.commands.display.*;
	import jp.progression.commands.lists.*;
	import jp.progression.commands.managers.*;
	import jp.progression.commands.media.*;
	import jp.progression.commands.net.*;
	import jp.progression.commands.tweens.*;
	import jp.progression.config.*;
	import jp.progression.data.*;
	import jp.progression.debug.*;
	import jp.progression.events.*;
	import jp.progression.loader.PRMLLoader;
	import jp.progression.scenes.*;
	import scene.*;
	
	/**
	 * ...
	 * @author Hidemasa Mori
	 */
	public class Index extends CastDocument 
	{
		private var _prmlLoader:PRMLLoader;
		
		/**
		 * 新しい Index インスタンスを作成します。
		 */
		public function Index() 
		{
			// 自動的に作成される Progression インスタンスの初期設定を行います。
			// 生成されたインスタンスにアクセスする場合には manager プロパティを参照してください。
			super( null, null, new WebConfig() );
			
			//PRMLで指定したクラスの宣言（無いとエラーになる）
			IndexScene;
			ThumnailScene;
			ProfileScene;
			DetailScene;
		}
		
		/**
		 * SWF ファイルの読み込みが完了し、stage 及び loaderInfo にアクセス可能になった場合に送出されます。
		 */
		override protected function atReady():void 
		{
			//PRMLからシーン作成
			_prmlLoader = new PRMLLoader(this);
			_prmlLoader.addEventListener(Event.COMPLETE, onPRMLComplete);
			_prmlLoader.load(new URLRequest("xml/scenedata.xml"));
		}
		
		/**
		 * PRMLローダーのCOMPLETEイベントハンドラ
		 * @param	e
		 */
		private function onPRMLComplete(e:Event):void 
		{
			_prmlLoader.removeEventListener(Event.COMPLETE, onPRMLComplete);
			_prmlLoader = null;
			
			// 開発者用に Progression の動作状況を出力します。
			Debugger.addTarget( manager );
			
			// 外部同期機能を有効化します。
			manager.sync = true;
			
			// 最初のシーンに移動します。
			manager.goto( manager.syncedSceneId );
			
			//ResourcePrefetcherへの登録
			var xmlData:XMLList = new XMLList(e.currentTarget.data);
			
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "op").swfSrc), new SceneId("/index/op"));
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "contents").swfSrc), new SceneId("/index/contents"));
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "about").swfSrc), new SceneId("/index/contents/about"));
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "price").swfSrc), new SceneId("/index/contents/price"));
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "service").swfSrc), new SceneId("/index/contents/service"));
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "voice").swfSrc), new SceneId("/index/contents/voice"));
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "request").swfSrc), new SceneId("/index/contents/request"));
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "applications").swfSrc), new SceneId("/index/contents/applications"));
			//ResourcePrefetcher.addRequest(new URLRequest(xmlData.scene..scene.(@name == "contact").swfSrc), new SceneId("/index/contents/contact"));
		}
	}
}
