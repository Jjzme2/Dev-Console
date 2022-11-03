component name="baseObject" accessors="true"{

	public BaseObject function init ()
	{
		return this;
	}

	public function toJSON()
	{
		return serializeJSON(this);
	}
}