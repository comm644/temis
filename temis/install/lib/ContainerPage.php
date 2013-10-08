<?php
require_once( dirname( __FILE__ ) . "/WizardPage.php");

/** template class for working with container

 just replace methods construct() and you will had complete wizard with subpages
 */
class ContainerPage extends WizardPage
{
	var $wizard;
	
	function construct()
	{
		//create wizard
		
		//$this->wizard = new Wizard('inner_guid', '' );
	}
	
	function run()
	{
		parent::run();
		$this->wizard->selectStep();
		return $this->wizard->run();
	}

	function next()
	{
		$this->wizard->selectStep();
		if ( $this->wizard->canMoveNext() ) {
			$this->wizard->next();
		}
		else {
			parent::next();
		}
	}
	function prev()
	{
		$this->wizard->selectStep();
		if ( $this->wizard->canMovePrev() ) {
			$this->wizard->prev();
		}
		else {
			parent::prev();
		}
	}
	function pages()
	{
		if ( $this->active ) {
			$this->wizard->selectStep();
			$first = reset( $this->wizard->stages );
			
			if ( $this->wizard->currentStage->id != $first->id ){
				$this->active = "";
			}
		}
		return $this->wizard->pages();
	}
}

?>