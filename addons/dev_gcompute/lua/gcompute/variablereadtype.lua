GCompute.VariableReadType = GCompute.Enum (
	{
		None                 = 0, -- error.
		Local                = 1, -- local a, a = val
		NamespaceMember      = 2, -- a = val or a.b = val
		Member               = 3, -- a.b = val
		Reference            = 4  -- T &a, a = val
	}
)