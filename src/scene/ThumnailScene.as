package scene 
{
	import asset.Sikaku;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import FMphysics.PhysicalPoint;
	import jp.iixx.mrhdms.util.DebugUtil;
	import jp.nium.utils.XMLUtil;
	import jp.progression.*;
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
	import jp.progression.loader.*;
	import jp.progression.scenes.*;
	
	/**
	 * ...
	 * @author Hidemasa Mori
	 */
	public class ThumnailScene extends SceneObject 
	{
		private var _buttonRect:Rectangle;
		private var _sikaku:Bitmap;
		private var _btnAry:Array;
		private var _pptAry:Array;
		private var _page:CastSprite;
		private var _sikakuPoint:Point;
		private var _pg:Graphics;
		
		/**
		 * 新しい ThumnailScene インスタンスを作成します。
		 */
		public function ThumnailScene( name:String = null, initObject:Object = null ) 
		{
			// 親クラスを初期化する
			super( name, initObject );
			
			_sikaku = new Bitmap(new Sikaku());
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは子階層だった場合に、階層が変更された直後に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneLoad():void 
		{
			//page.getChildAt(0).addEventListener(Event.COMPLETE, compOpHandler);
			var xmlData:XMLList = new XMLList(dataHolder.data);
			var obj:Object = XMLUtil.xmlToObject(xmlData);
			
			//シーンタイトル
			title = obj.title;
			
			//初期化			
			_btnAry = [];
			_pptAry = [];
			
			_page = new CastSprite();
			_pg = _page.graphics;
			
			//サムネールロードしてパーツ作る
			var ll:LoaderList = new LoaderList();
			var thumLen:uint = xmlData.thumPath.length();
			
			for (var i:int = 0; i < thumLen; i++) 
			{
				ll.addCommand(
					new LoadSWF(new URLRequest(xmlData.thumPath[i].toString()),new CastLoader())
				);
			}
			
			//四角の配置
			_buttonRect = Singleton.getInstance.naviInfo[manager.currentSceneId.toString()]["rect"] as Rectangle;
			_sikaku.x = _buttonRect.x + _buttonRect.width + 16;
			_sikaku.y = 26/*ボタンの高さの半分*/ + _buttonRect.y - int(_sikaku.height / 2) + 123;
			//線が出るポイント
			_sikakuPoint = new Point(_sikaku.x + _sikaku.width, _sikaku.y + _sikaku.height / 2);
			
			addCommand(
				new AddChild(container, _page),
				new AddChild(_page, _sikaku),
				ll,
				new Func(function():void {
					//サムネール画像の読み込み完了後、ボタンを生成、配置
					for (var j:int = 0; j < thumLen; j++) 
					{
						var thumBtn:ThumnailButton = new ThumnailButton( { link:xmlData.thumPath[j].@link, imgPath:xmlData.thumPath[j].toString() } );
						thumBtn.x = 200 * (j+1);
						thumBtn.y = -200;
						
						insertCommand(new AddChild(_page, thumBtn));
						_btnAry.push(thumBtn);
						_pptAry.push(new PhysicalPoint(200 * (j+1),-200));
					}
					}),
				moveStart
			);
		}
		
		/**
		 * シーンオブジェクト自身が目的地だった場合に、到達した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneInit():void 
		{
			addCommand(
				new DoTweener(_page,{alpha:1,time:1})
			);
		}
		
		//サムネールボタンのアニメーションスタート
		private function moveStart():void 
		{
			CastDocument.stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
			CastDocument.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler);
		}
		
		private function stage_activateHandler(e:Event):void 
		{
			
			CastDocument.stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
		}
		
		private function stage_deactivateHandler(e:Event):void 
		{
			CastDocument.stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
			CastDocument.stage.addEventListener(Event.ACTIVATE, stage_activateHandler);
		}
		
		private function stage_enterFrameHandler(e:Event):void 
		{
			var len:uint = _pptAry.length;
			for (var i:int = 0; i < len; i++) 
			{
				//if (draggingFairy == fairy[i]) 
				//{
					//ppt[i].x = fairy[i].x;
					//ppt[i].y = fairy[i].y;
				//} else {
					for (var j:int = 0; j < len; j++) 
					{
						if (i != j) 
						{
							//ボタン通しの距離
							var dist:Number = Point.distance(_pptAry[i], _pptAry[j]);
							//ボタン通しの角度
							var dire:Number = Math.atan2(_pptAry[j].y - _pptAry[i].y, _pptAry[j].x - _pptAry[i].x);
							//ボタン通しが保つ距離
							var theDistance:Number = 200;
							if (dist > theDistance) 
							{
								_pptAry[i].setKasokudoByPolar(Math.abs(dist - theDistance) * Math.random() * 0.5, dire);
							} else {
								_pptAry[i].setKasokudoByPolar(Math.abs(dist - theDistance) * Math.random() * 100, dire + Math.PI + (Math.random() * 0.5 - 0.5));
							}
						} else {
							//目標となる固定点
							var point:Point = new Point(630, CastDocument.middle);
							if (ThumnailButton(_btnAry[i]).hitTestPoint(CastDocument.stage.mouseX,CastDocument.stage.mouseY)) 
							{
								point = new Point(CastDocument.stage.mouseX, CastDocument.stage.mouseY);
							}
							//ボタンと固定点との距離
							var dist2:Number = Point.distance(_pptAry[i], point);
							//ボタンと固定点の角度
							var dire2:Number = Math.atan2(point.y - _pptAry[i].y, point.x - _pptAry[i].x);
							//ボタンと固定点が保つ距離
							var theDistance2:uint = 50;
							
							if (dist2 > theDistance2) 
							{
								//マウスが乗ってるとき
								if (ThumnailButton(_btnAry[i]).hitTestPoint(CastDocument.stage.mouseX, CastDocument.stage.mouseY)) 
								{
									_pptAry[i].setKasokudoByPolar(Math.abs(dist2 - theDistance2) * Math.random() * 20, dire2);
								} else {
									//マウス乗ってないとき
									if (dist2 > theDistance2 * 4) 
									{
										_pptAry[i].setKasokudoByPolar(Math.abs(dist2 - theDistance2) * Math.random() * 10, dire2);
									} else {
										_pptAry[i].setKasokudoByPolar(Math.abs(dist2 - theDistance2) * Math.random() * 0.5, dire2);
									}
								}
							} else {
								
								_pptAry[i].setKasokudoByPolar(Math.abs(dist2 - theDistance2) * Math.random() * 0.5, dire2 + Math.PI);
								
							}
						}
					}
				//}
			}
			
			_pg.clear();
			_pg.lineStyle(1, 0xFFFFFF);
			for (i = 0; i < len; i++) 
			{	
				
				_btnAry[i].x = _pptAry[i].x;
				_btnAry[i].y = _pptAry[i].y;
				
				//ラインの描画
				var vp:Point = new Point(_btnAry[i].x - _sikakuPoint.x, _btnAry[i].y - _sikakuPoint.y);
				_pg.moveTo(_sikakuPoint.x, _sikakuPoint.y);
				_pg.curveTo(_sikakuPoint.x + vp.x / 4*1, _sikakuPoint.y + vp.y / 3*1.0, _sikakuPoint.x + vp.x / 2, _sikakuPoint.y + vp.y / 2);
				_pg.curveTo(_sikakuPoint.x + vp.x / 4*3, _sikakuPoint.y + vp.y / 3*1.9, _sikakuPoint.x + vp.x / 1, _sikakuPoint.y + vp.y / 1);
				
			}
		}
		
		/**
		 * シーンオブジェクト自身が出発地だった場合に、移動を開始した瞬間に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneGoto():void 
		{
			
			addCommand(
				new DoTweener(_page,{alpha:0,time:0.5})
			);
		}
		
		/**
		 * シーン移動時に目的地がシーンオブジェクト自身もしくは親階層だった場合に、階層が変更される直前に送出されます。
		 * このイベント処理の実行中には、ExecutorObject を使用した非同期処理が行えます。
		 */
		override protected function atSceneUnload():void 
		{
			addCommand(
				new RemoveAllChildren(_page),
				new RemoveChild(container, _page),
				function():void {
					CastDocument.stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
					CastDocument.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
					CastDocument.stage.removeEventListener(Event.DEACTIVATE, stage_deactivateHandler);
				}
			);
		}
		
		
	}
}
