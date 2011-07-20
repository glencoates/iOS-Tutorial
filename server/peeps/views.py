# Create your views here.

import json
from django.http import HttpResponse

PEEPS = (
    {"name": "Bella Acton",
     "skills": ("Being awesome", "Making cups of tea", "Deserting the labs")},

    {"name": "Dick Talens",
     "skills": ("Picking Django over Rails", "Benchpressing the rest of his team")},

    {"name": "Dave Cascino",
     "skills": ("Getting in the zone", "Having a bigger screen than me")},

    {"name": "Jesse Middleton",
     "skills": ("Working all day on an 11\" screen", "Letting Matt be the mayor of the labs")} )


def peeps( request ):
    return HttpResponse( json.dumps( PEEPS ) )
