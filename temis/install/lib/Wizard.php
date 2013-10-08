<?php
require_once( dirname( __FILE__ ) . "/WizardPage.php");

class Wizard
{
	function Wizard($wizardGUID)
	{
		$this->wizardKey  =  $wizardGUID;
		$this->lastAdded = "";
		$this->firstStep = "";

		$this->loadState();
	}
	function pages()
	{
		return $this->stages;
	}

	function add( $page )
	{
		if ( !$this->firstStep ) {
			$this->firstStep = $page->id;
		}
		if ( $this->lastAdded != "" ) {
			$page->prevId = $this->lastAdded;
			$this->stages[$this->lastAdded]->nextId = $page->id;
		}
		$page->setOwner( $this );
		$this->stages[$page->id] =$page;
		$this->lastAdded = $page->id;
	}

	function _setCurrenStep( $id )
	{
		if ( !array_key_exists( $id, $this->stages ) )
		{
			$id = $this->firstStep;
		}
		if ( !array_key_exists( $id, $this->stages ) ){
			trigger_error('Invalid pageId', E_USER_ERROR );
		}
		$this->currentStage = &$this->stages[ $id ];
		$this->currentStage->active ='active';
		return $this->currentStage;
	}

	function selectStep()
	{
		if ( !array_key_exists( $this->state->step, $this->stages ) )
		{
			$this->state->step = $this->firstStep;
			$this->saveState();
		}
		$this->_setCurrenStep( $this->state->step );
	}

	function reload()
	{
		$uri  =$_SERVER['REQUEST_URI'];
		header("Location: {$uri}");
		exit;
	}


	function loadState()
	{
		if ( !array_key_exists( $this->wizardKey , $_SESSION ) ) {
			$state = new stdclass;
			$state->step = $this->firstStep;
			$_SESSION[ $this->wizardKey ] = $state;
		}
		$this->state = $_SESSION[ $this->wizardKey  ];
	}

	/**
	 * Get wizard page
	 * 
	 * @param string $name
	 * @return WizardPage
	 */
	function getPage( $name )
	{
		return $this->stages[ $name ];
	}

	function saveState()
	{
		$_SESSION[ $this->wizardKey ] = $this->state;
	}

	function moveNext()
	{
		$this->selectStep();
		if ( $this->currentStage->canMoveNext() ) {
			$this->state->step = $this->currentStage->nextId();
			$this->saveState();
		}
		$this->selectStep();
	}
	
	function movePrev()
	{
		$this->selectStep();
		if ( $this->currentStage->canMovePrev()  ) {
			$this->state->step = $this->currentStage->prevId();
			$this->saveState();
		}
		$this->selectStep();
	}



	function canMoveNext()
	{
		return $this->currentStage->canMoveNext();
	}
	function canMovePrev()
	{
		return $this->currentStage->canMovePrev();
	}

	function run()
	{
		return $this->currentStage->run();
	}
	function next()
	{
		return $this->currentStage->next();
	}
	function prev()
	{
		return $this->currentStage->prev();
	}

}

?>