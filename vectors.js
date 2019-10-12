<script>
	V={
		s: function(a, b)
		{
			return [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
		},				
		
		p: function(a, b)
		{
			return [a[0]*b[0], a[1]*b[1], a[2]*b[2]];
		},
		
		ps: function(k, a)
		{
			return [k*b[0], k*b[1], k*b[2]];
		},
		
		pv: function(a, b)
		{
			return [a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]];
		}
		
		o: function(a)
		{
			return [-a[0], -a[1], -a[2]];
		}
	}
</script>