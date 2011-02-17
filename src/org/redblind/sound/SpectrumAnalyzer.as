package org.redblind.sound
{
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class SpectrumAnalyzer
	{
		/**
		 * Computes and returns and array of sound bands
		 * #param	channel			0 (left) or 1 (right) channel
		 * #param	FFTMode			frequency spectrum (true) or raw sound wave (false)
		 * #param	numOfbands		number of bands to return
		 */
		public static function computeBandArray(channel:int=0,FFTMode:Boolean=true,numOfbands:int=256):Array {
			var bandFactor:int = 256/numOfbands;
			var bandArray:Array = new Array();
			var byteArray:ByteArray = new ByteArray();
			SoundMixer.computeSpectrum(byteArray,FFTMode,numOfbands);
			
			var i:int;
			var trgtBandFactor:int = 0;
			for(i=0;i<512;i++){
				var level:Number = byteArray.readFloat();
				if(i==trgtBandFactor){
					if(channel==0 && i<256){
						bandArray.push(level);
					}
					else if(channel==1 && i>=256){
						bandArray.push(level);
					}
					trgtBandFactor+=bandFactor;
				}
			}
			return bandArray;
		}
	}
}