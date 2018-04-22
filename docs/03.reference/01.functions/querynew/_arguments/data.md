data to populate the new Query, an array of arrays or an array of structs.

Example usage:
queryNew("name,age","varchar,numeric",[["Susi",20],["Urs",24]]);
queryNew("name,age","varchar,numeric",[[name:"Susi",age:20],[name:"Urs",age:24]]);
queryNew("name,age","varchar,numeric",{name:["Susi","Urs"],age:[20,24]});