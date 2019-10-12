package
{
	public class V 
	{
		
		public function V() 
		{
			
		}
		
		public static function s(a, b)
		{
			return [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
		}

		public static function d(a, b)
		{
			return [a[0]-b[0], a[1]-b[1], a[2]-b[2]];
		}
		
		public static function p(a, b)
		{
			return [a[0]*b[0], a[1]*b[1], a[2]*b[2]];
		}
		
		public static function ps(k, a)
		{
			return [k*a[0], k*a[1], k*a[2]];
		}
		
		public static function pv(a, b)
		{
			return [a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]];
		}
		
		public static function o(a)
		{
			return [-a[0], -a[1], -a[2]];
		}
		
		public static function abs(a)
		{
			return Math.sqrt(a[0]*a[0]+a[1]*a[1]+a[2]*a[2]);
		}
		
		public static function norm(a)
		{
			var abs=V.abs(a);
			if(abs==0) return [0, 0, 0];
			return V.ps(1/abs, a);
		}	
		
	}

}