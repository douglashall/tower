<%@ page import="tower.Message" %>
<!DOCTYPE html>
<html>
  <head>
    <meta name="layout" content="main">
    <title>Tower</title>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load("visualization", "1", {packages:["corechart"]});
      google.setOnLoadCallback(drawChart);

      var data = {};
      <g:each var="entry" in="${messages}">
        var data_${entry.key.replaceAll('\\.', '_')} = [];
        <g:each in="${entry.value}">
          data_${entry.key.replaceAll('\\.', '_')}.push({
            host: '${it.host}',
            source: '${it.source}',
            url: '${it.url}', 
            params: '${it.params}',
            status: '${it.status}',
            requestSent: '<g:formatDate date="${new Date(it.requestSent)}" type="datetime" style="LONG"/>',
            responseReceived: '<g:formatDate date="${new Date(it.requestSent)}" type="datetime" style="LONG"/>',
            duration: <g:formatNumber number="${it.getDuration()}" type="number" format="###.###"/>,
          });
        </g:each>
        data['${entry.key.replaceAll('\\.', '_')}'] = data_${entry.key.replaceAll('\\.', '_')};
      </g:each>

      function drawChart() {
    	  var arr, dataTable, chart;
    	  var options = {
          title: '',
          vAxis: {title: 'Request'},
          hAxis: {title: 'Time (Seconds)'},
          legend: {position: 'none'}
        };
        <g:if test="${messages.size() > 0}">
        <g:each var="entry" in="${messages}">
          arr = [
            ['Path', 'Time (Seconds)']
          ];
          <g:each in="${entry.value}">
            arr.push(['${it.url}', <g:formatNumber number="${it.getDuration()}" type="number" format="###.###"/>]);
          </g:each>
          dataTable = google.visualization.arrayToDataTable(arr);
          options.title = '${entry.key}';
          chart = new google.visualization.BarChart(document.getElementById('chart_div_${entry.key.replaceAll('\\.', '_')}'));
          chart.draw(dataTable, options);
          google.visualization.events.addListener(chart, 'select', $.proxy(handleSelect, chart));
        </g:each>
        </g:if>
      }
      function handleSelect(event) {
          var chart = this.cd.id.substring(10);
          var selection = this.getSelection()[0].row;
          var sData = data[chart][selection];
          alert(
            "Response received: " + sData.responseReceived + "\n" +
            "Host: " + sData.host + "\n" +
            "Source: " + sData.source + "\n" +
            "Request: " + sData.url + "\n" +
            "Parameters: " + sData.params + "\n" +
            "Duration: " + sData.duration + "\n"
          );
      }
    </script>
  </head>
  <body>
    <div id="list-message" class="content scaffold-list" role="main">
      <h1>Slowest Requests By Host</h1>
      <g:each var="entry" in="${messages.entrySet()}">
        <div id="chart_div_${entry.key.replaceAll('\\.', '_')}" style="width: 900px; height: 500px;"></div>
      </g:each>
    </div>
  </body>
</html>
