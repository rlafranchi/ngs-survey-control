<h3>A simple search engine for NGS Survey Control Points</h3>

<p>A demo can be found at <a href="https://ngs-survey-control.herokuapp.com">https://ngs-survey-control.herokuapp.com</a>.  The application is built on ruby on rails, but the file at app/services/ngs_query.rb could be applied to any ruby project.  It only depends on the Faraday gem.  Results are limited to a maximum of a 10 mile radius.</p>

<a href="http://ngs.noaa.gov">ngs.noaa.gov</a>

Queries are made to <a href="http://maps1.arcgisonline.com/ArcGIS/rest/services/NGS_Survey_Control_Points/MapServer/1">http://maps1.arcgis.com/ArcGIS/rest/services/NGS_Survey_Control_Points/MapServer/1</a>