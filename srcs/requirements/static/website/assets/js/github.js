const token = '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'; // only give acces to read my public repo ;)
const username = 'gazhonsepaskwa';

const query = `
			{
			user(login: "${username}") {
				pinnedItems(first: 6, types: REPOSITORY) {
				nodes {
					... on Repository {
					name
					description
					url
					stargazerCount
					forkCount
					}
				}
				}
			}
			}
			`;

fetch('https://api.github.com/graphql', {
	method: 'POST',
	headers: {
		'Authorization': `Bearer ${token}`,
		'Content-Type': 'application/json'
	},
	body: JSON.stringify({ query })
})
	.then(response => response.json())
	.then(data => {
		const repos = data.data.user.pinnedItems.nodes;
		const repoDiv = document.getElementById('repos');

		if (repos.length === 0) {
			repoDiv.innerHTML = '<p>No pinned repositories found.</p>';
			return;
		}

		repoDiv.innerHTML = repos.map(repo => `
					<div class="skills__content">
						<h3 class="project__title">${repo.name}</h3>
						<p class="project__description">${repo.description}</p>
						<p class="project__description"> <i class="ri-star-line"></i> ${repo.stargazerCount}</p>
						<a href="${repo.url}" target="_blank" class="project__link">View Project
									<i class="ri-arrow-right-line"></i></a>
					</div>
				`).join('');
	})
	.catch(error => {
		console.error('Error fetching pinned repositories:', error);
		document.getElementById('repos').innerHTML = 'Could not load pinned repositories.';
	});
