const search = document.getElementById('search');
const matchList = document.getElementById('match-list');

// Search .json and filter it
const searchAnalysis = async searchText => {
	const res = await fetch('https://brnpdb.fcfrp.usp.br/schema/analysis.json');
	const analysis = await res.json();

	let matches = analysis.filter(analysis => {
		const regex = new RegExp(`^${searchText}`, 'gi');
		return analysis.City_ID_IBGE.match(regex);
	});

	if(searchText.lenght === 0){
		matches = [];
		matchList.innerHTML = '';
	}

	outputHtml(matches);
};

// Show results in HTML
const outputHtml = matches => {
	if(matches.lenght > 3){
		const html = matches
		.map(
			match => `
			<div class="card card-body mb-1">
			 <h4>${match.City_ID_IBGE} (${match.State_ID_IBGE}) <span 
			 class="text-primary">${
			 	match.Biological_Property_ID
			 }</span></h4>
			 <small>Resource: ${match.Natural_Resource_ID} / Species: ${match.Species_ID}</small>
			 </div>
			`
		)
		.join('');
		
		matchList.innerHTML = html;
	}
}

search.addEventListener('input', () => searchAnalysis(search.value));
