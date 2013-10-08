<?php
if (! file_exists(TEMIS_DIR . "/settings/config.php")) {

	//echo "Error: TEMIS was not installed. Please install first. (DIR_MODULES/temis/install)";
	

	class Temis_CheckInstall
	{

		function get_relative_path ($start_dir, $final_dir)
		{

			//
			$firstPathParts = explode(DIRECTORY_SEPARATOR, $start_dir);
			$secondPathParts = explode(DIRECTORY_SEPARATOR, $final_dir);
			//
			$sameCounter = 0;
			for ($i = 0; $i < min(count($firstPathParts), count($secondPathParts)); $i ++) {
				if (strtolower($firstPathParts[$i]) !== strtolower($secondPathParts[$i])) {
					break;
				}
				$sameCounter ++;
			}
			if ($sameCounter == 0) {
				return $final_dir;
			}
			//
			$newPath = '';
			for ($i = $sameCounter; $i < count($firstPathParts); $i ++) {
				if ($i > $sameCounter) {
					$newPath .= DIRECTORY_SEPARATOR;
				}
				$newPath .= "..";
			}
			if (count($newPath) == 0) {
				$newPath = ".";
			}
			for ($i = $sameCounter; $i < count($secondPathParts); $i ++) {
				$newPath .= DIRECTORY_SEPARATOR;
				$newPath .= $secondPathParts[$i];
			}
			//
			return $newPath;
		}

		function getUrlPath ()
		{
			$uri = $_SERVER['REQUEST_URI'];
			$parts = parse_url($uri);
			$path = $parts['path'];
			if (!end( explode( '/' , $path ) ) ) {
			    return $path;
			}
			
			//$parts = pathinfo( $path ); //TODO check extension
			return dirname($path);
		}

		function getRelativeLocation ()
		{
			$entryPoint = end(debug_backtrace());
			$entryPointFile = $entryPoint['file'];
			
			$temisRelative = $this->get_relative_path(dirname($entryPointFile), dirname(__FILE__));
			$temisRelative = str_replace('\\', '/', $temisRelative); //convert to Url
			return $temisRelative;
		}

		function install ()
		{

			$temisRelative = $this->getRelativeLocation();
			$rootPath = $this->getUrlPath();
			
			
			$installLocation = "{$rootPath}{$temisRelative}/install";
			header("Location: $installLocation");
		}
	}
	
	$obj = new Temis_CheckInstall();
	$obj->install();
	exit();
}

?>