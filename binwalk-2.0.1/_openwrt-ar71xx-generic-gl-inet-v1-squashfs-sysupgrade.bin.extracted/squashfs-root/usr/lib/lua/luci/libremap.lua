LuaQ               
2   
   E   @  \    Á   Å   Á  Ü   A  E  A \   Á  Å  Â Ü $          	   AB  dB        	@d        	@dÂ              	@d       	@          require    luci.fs    luci.httpclient 
   luci.json 	   luci.sys    string    nixio    luci.libremap.util    gather    luci.ltn12    http    fetch    fetch_by_name    submit           Y    ]   [A    J  W @A@WÀ  @ÁÁ   [B   AB  ÆB@Ã A  Á B @ D FÂ¤              äC       \Cã  !   ü ÂBA  KBCÁ \ J IBIBDIÂD E IIÂB  Ê ÉBFÉÉÇÉÂIW @@ÂCIB@IGIB ÀÄ ÆÂ$          dÄ       ÜCc  ¡  ü^          _rev    syslog    warning    revision mismatch (    nil     !=     ) 	      pairs    try    exec *   opkg status libremap-agent | grep Version    match    ^Version: (.*)
    _id    api_rev    1.0    type    router 	   hostname 
   community    attributes 
   submitter    name    libremap-agent-openwrt    version    url 3   https://github.com/libremap/libremap-agent-openwrt    plugins    ctime        *   1           D    Å@    D AÜ À Ä  À	  D    	    A           module    require    luci.libremap.plugins.    options 	                       1   3    
   D   F À @  Á   AÁ    Õ\@        syslog    warning    unable to load plugin "    ";                      Q   S     	       @ @@ D     @Ä  @         module    insert    options                     S   U    
   D   F À @  Á   AÁ    Õ\@        syslog    warning    unable to execute plugin "    ";                                  c   s    6       @À     @@  À ÁA     ÆÀÆÁÀ ÁÄ  ÆAÁ @ ÜÀÄ ÆÁÆÁÁ AB@  KBÂ\ Ü  Ê   BÂB@  CBCÀ BB C@ @ À         request_raw 	ÿÿÿÿ   headers    Transfer-Encoding    chunked    chunksource    source    cat    string    blocksource    pump    all    sink    table    concat                     w       &   Z@  @         @À   A  @ Õ@ XÀ@ ÀW Á@EA  À Â @   ÛB  ÁB  \A  D FÁÂ ] ^  C^         http 	   /router/ 	È   	,  	     error    could not determine if id  $    is already available under API at      (code     nil    )    decode                        ª    C   Z@  @       @@Ê  
 D  FÁÀ\  "A â@ À Ê@  É@A ÁA@  É  B@  A UXÂ@ @ W Ã ÅA  @  Â ÛB  Á C ÜA @Ä ÆÄ  Ü ÂÄ  E ÂÄEBE  EAÂ  BÃÞ         include_docs    keys 	   hostname    method    POST    body    encode    http    /routers_by_name_community/ 	È   	,  	     error ?   could not determine if router is already present under API at      (code     nil    )    decode    rows 	      value    syslog    warning B   more than one record matches the criteria. fetch by name aborted.                     ®   É    1   @  Ê@  ÉÀÀ À   Á  Õ Á @A@ ÀAÀ  B FÁ Õ@  B@    ÁB@ X Ã@ @Å Â @ À ÂÜA ÆADÁ B     D@  ÂD@        headers    Content-Type    application/json 	   /router/    _id     method    POST    PUT    body    encode    http 	È   	,     error 0   error creating/updating router document at URL     ;     X-Couch-Update-NewRev    decode    id                             