<?php

class uiFile_FileInfo
{
	/**
	 * original filename
	 *
	 * @var string
	 */
	var $name;
	
	/**
	 * temporary filename (uploaded)
	 *
	 * @var string
	 */
	var $tmpname;
	
	/**
	 * Mime type
	 *
	 * @var string
	 */
	var $type;
	
	/**
	 * error code, zero on success
	 *
	 * @var integer
	 */
	var $error;
	
	/**
	 * File size
	 *
	 * @var integer
	 */
	var $size;
	
	
	/**
	 * construct file info
	 *
	 * @param stirng $name
	 * @param string $type
	 * @param integer $size
	 * @param string $tmpname
	 * @param integer $error
	 * @return uiFile_FileInfo
	 */
	function uiFile_FileInfo($name, $type, $size, $tmpname, $error)
	{
		$this->name = $name;
		$this->type = $type;
		$this->size = $size;
		$this->tmpname = $tmpname;
		$this->error = $error;
	}

	/**
	 * @return integer
	 */
	function getError ()
	{
		return $this->error;
	}

	/**
	 * @return string
	 */
	function getName ()
	{
		return $this->name;
	}

	/**
	 * @return integer
	 */
	function getSize ()
	{
		return $this->size;
	}

	/**
	 * @return string
	 */
	function getTmpname ()
	{
		return $this->tmpname;
	}

	/**
	 * @return string
	 */
	function getType ()
	{
		return $this->type;
	}

	/**
	 * Get error as string 
	 *
	 * @return string
	 */
	function getErrorString()
	{
		switch( $this->error ) {
		case UPLOAD_ERR_INI_SIZE:  return "The uploaded file exceeds the upload_max_filesize directive in php.ini";
		case UPLOAD_ERR_FORM_SIZE: return "The uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the HTML form.";
		case UPLOAD_ERR_PARTIAL:   return "The uploaded file was only partially uploaded.";
		case UPLOAD_ERR_NO_FILE:   return "No file was uploaded.";
		case UPLOAD_ERR_NO_TMP_DIR: return "Missing a temporary folder. Introduced in PHP 4.3.10 and PHP 5.0.3.";
		case UPLOAD_ERR_CANT_WRITE: return "Failed to write file to disk. Introduced in PHP 5.1.0.";
		case UPLOAD_ERR_EXTENSION:  return "File upload stopped by extension. Introduced in PHP 5.2.0.";
		}
		return "Success";
	}
}
class uiFile extends uiWidget 
{
	function onLoad($sender, $selfname )
	{
		$files = &$_FILES[$selfname];
		
		//only first load, becase files will be deleted after processing page
		if ( $files == null || count( $files) == 0 ) {
			$this->files = array();
			return; 
		}
		
		//resample files
		
		$info = array();
		foreach( $files as $property => $items ) { //resample
			$array = $items;
			if ( !is_array($array)) $array = array( $array);

			foreach( $array as $index => $value ) {
				if ( !array_key_exists($index, $info)) {
					$info[ $index ] = array();
				}
				$info[ $index ][ $property ] = $value;
			}
		}
		
		$this->files = array();
		foreach( $info as $index => $fileinfo ) {
			if ( !is_uploaded_file($fileinfo['tmp_name'])) continue;
			
			$this->files[ $index ] = 
				new uiFile_FileInfo(
					$fileinfo['name'],
					$fileinfo['type'],
					$fileinfo['size'],
					$fileinfo['tmp_name'],
					$fileinfo['error']
				);
		}
	}

	/**
	 * returns array of uploaded files
	 *
	 * @return array(uiFile_FileInfo) 
	 */
	function getFiles()
	{
		return $this->files;
	}
}
?>