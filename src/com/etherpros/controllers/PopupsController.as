package com.etherpros.controllers
{
	import com.etherpros.components.popups.LoadingPopup;
	
	import flash.display.DisplayObject;
	
	import mx.managers.PopUpManager;

	public class PopupsController
	{
		private var container:DisplayObject;		
		// LoadingPopup is kept in memory since it is used so often.
		private var loadingPopup:LoadingPopup = new LoadingPopup();
		
		public function PopupsController(container:DisplayObject) {
			this.container = container;
		}
		
		public function showLoading():void {
			PopUpManager.addPopUp(loadingPopup, container, true);
			PopUpManager.centerPopUp(loadingPopup);
		}
		
		public function hideLoading():void {
			PopUpManager.removePopUp(loadingPopup);
		}
		
	}
}