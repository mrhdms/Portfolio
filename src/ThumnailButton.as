package  
{
	import flash.display.Sprite;
	import jp.iixx.mrhdms.util.NumUtil;
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
	 * ...
	 * @author Hidemasa Mori
	 */
	public class ThumnailButton extends CastButton 
	{
		
		/**
		 * 新しい ThumnailButton インスタンスを作成します。
		 */
		public function ThumnailButton( initObject:Object = null ) 
		{
			// 親クラスを初期化します。
			super( initObject );
			
			// 移動先となるシーン識別子を設定します。
			sceneId = new SceneId(initObject.link);
			
			
			//丸を描画
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawCircle( 0, 0, 80);
			this.graphics.endFill();
			
			//マスク
			var maskSp:Sprite = new Sprite();
			maskSp.graphics.beginFill(0x000000);
			maskSp.graphics.drawCircle( 0, 0, 75);
			maskSp.graphics.endFill();
			
			//サムネール画像
			var img:CastLoader = getResourceById(initObject.imgPath).data as CastLoader;
			img.scaleX = img.scaleY = NumUtil.scaleRatioByShortSide(img.width, img.height, 150, 150);
			img.x = img.width / -2;
			img.y = img.height / -2;
			
			img.mask = maskSp;
			addChild(img);
			addChild(maskSp);
			
			
			// 外部リンクの場合には href プロパティに設定します。
			//href = "http://progression.jp/";
		}
		
		/**
		 * IExecutable オブジェクトが AddChild コマンド、または AddChildAt コマンド経由で表示リストに追加された場合に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastAdded():void 
		{
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
			Singleton.getInstance.sound2.play();
		}
		
		/**
		 * ユーザーが CastButton インスタンスからポインティングデバイスを離したときに送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atCastRollOut():void 
		{
		}
	}
}