The XQuery folder contains useful scripts for managing a jive community. You can execute these scripts on your local machine or from a Nitrious.IO instance.

In order to process these queries you will need to install an XQuery process. I recommend <a href="http://www.basex.org">BaseX</a>.

<h2>Setting up BaseX on Nitrious.IO<h2>

From your Nitrious.IO console download the latest <a href="http://www.basex.org">BaseX</a> instance zip file:

(I hope to have an autopart soon) For now you can execute these commands from a console:
<pre><code>
  wget 'http://files.basex.org/releases/7.9/BaseX79.zip'
  unzip BaseX79.zip -d /home/action/workspace

</code></pre>

You can find nigthly builds here: 'http://files.basex.org/releases/latest/'<p>
For efficiency you can add basex/bin to your path by executing:

<pre><code>
  export PATH=$PATH:/home/action/workspace/basex/bin

</code></pre>

<h3>Executing queries</h3>
Now that we have added the BaseX bin folder to your path. You can easily execute XQuery scripts and commands directly from the console. You can find details <a href="http://docs.basex.org/wiki/Command-Line_options">here</a>. 

To execute a query use the <code>-q</code> parameter followed by the query.

<pre><code>
  basex -q 'for $f in file:list("/home/action/workspace/") return $f'

</code></pre>

You can execute script files simply with their path:

<pre><code>
  basex query-file.xq
  
</pre></code>

If your modules defines <a href="http://docs.basex.org/wiki/XQuery_3.0#External_Variables">External Variables</a> you can bind them via the -b paramter. This paramter can be bound multiple times. For example:<p>

<pre><code>
  basex -bmyVar=SomeValue -botherVar='This value' query-file.xq
  
</code></pre>

<h3>Exposing queries as REST endpoints</h3>
BaseX comes coupled with a jetty/tomcat webservice. If you naviagte to the BaseX folder created during the setup process. You will note a 'webapp' folder. Any modules placed within this folder and properly annotated with <a href="http://docs.basex.org/wiki/RESTXQ">RESTXQ annotation</a> will be exposed as a REST endpoints. 

<h4>Setup webservice for Nitrious.IO previewing</h4>
BaseX comes with a sample page which can be found at 'webapp/restxq.xqm'

In order to use the Nitrious.IO preview feature lets configure the port the BaseX server will start on. In the console, navigate to the webapp/WEB-INF folder and update the jetty.xml file's port paramter from 8984 to 3000.

Alternatively you can run this command from the console:

<pre><code>
  sed 's/8984/3000/' jetty.xml -i 
  
</code></pre>

Once the file has been edited and basex/bin has been added to your path you can start the basex server simply with:

<pre><code>
  basexhttp
  
</code></pre>

From Nitrious.IO select Preview -> Port 3000.

<h4>Static Content</h4>
You can also expose static content such as images, scripts, etc via the 'webapp/static' folder. 

Happy Querying!

