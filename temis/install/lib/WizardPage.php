<?php
class WizardPage
{
	var $active = '';
	function WizardPage( $id, $caption, $nextid="", $errorId="" )
	{
		$this->id = $id;
		$this->caption = $caption;
		$this->nextId = $nextid;
		$this->prevId = "";
		$this->errorId = $errorId;

		$this->construct();
	}

	function setOwner( &$owner )
	{
		$this->owner = &$owner;
	}
	
	/** preform actions for page

	@return  true if continue enabled, or false
	 */
	function run()
	{
		return false;
	}

	function next()
	{
		$this->owner->moveNext();
	}
	function prev()
	{
		$this->owner->movePrev();
	}
	function canMoveNext()
	{
		return $this->nextId != "";
	}
	function canMovePrev()
	{
		return $this->prevId != "";
	}

	
	
	function nextId()
	{
		return $this->nextId;
	}
	function prevId()
	{
		return $this->prevId;
	}
	function error()
	{
		return $this->errorId;
	}

	/** should to return  list of substeps
	 */
	function pages()
	{
		return array();
	}

	/** virtual constructor
	 */
	function construct()
	{
	}
}
?>