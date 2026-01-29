<h1>
	Configuration Stack Apache Guacamole
</h1>
<p>
	Ce dépôt contient la configuration des variables d'environnement nécessaires au déploiement d'une instance 
	<strong>
		Apache Guacamole
	</strong>
	 s'appuyant sur une base de données 
	<strong>
		PostgreSQL
	</strong>
	.
</p>
<h2>
	📋 Variables de Configuration
</h2>
<p>
	Les variables sont réparties par composants pour faciliter la maintenance.
</p>
<h3>
	⚙️ Paramètres Communs
</h3>
<figure class="table">
	<table>
		<thead>
			<tr>
				<th style=";">
					<strong>
						Variable
					</strong>
				</th>
				<th style=";">
					<strong>
						Description
					</strong>
				</th>
				<th style=";">
					<strong>
						Valeur par défaut
					</strong>
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							RESTART_POLICY
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Politique de redémarrage des conteneurs Docker.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							always
						</span>
					</code>
				</td>
			</tr>
		</tbody>
	</table>
</figure>
<hr>
<h3>
	🐘 Base de données (PostgreSQL)
</h3>
<p>
	Configuration relative au stockage des données utilisateurs et des configurations de connexion.
</p>
<figure class="table">
	<table>
		<thead>
			<tr>
				<th style=";">
					<strong>
						Variable
					</strong>
				</th>
				<th style=";">
					<strong>
						Description
					</strong>
				</th>
				<th style=";">
					<strong>
						Valeur par défaut
					</strong>
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							POSTGRESQL_HOSTNAME
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Nom d'hôte du service de base de données.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							guacamole-db
						</span>
					</code>
				</td>
			</tr>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							POSTGRESQL_DATABASE
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Nom de la base de données Guacamole.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							guacamole
						</span>
					</code>
				</td>
			</tr>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							POSTGRESQL_USERNAME
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Utilisateur de la base de données.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							guacamole
						</span>
					</code>
				</td>
			</tr>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							POSTGRESQL_PASSWORD
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Mot de passe de l'utilisateur.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							changeme
						</span>
					</code>
				</td>
			</tr>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							PGDATA
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Chemin de persistance des données PostgreSQL.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							/var/lib/postgresql/18/docker
						</span>
					</code>
				</td>
			</tr>
		</tbody>
	</table>
</figure>
<hr>
<h3>
	🌐 Interface Web (Guacamole Client)
</h3>
<p>
	Paramètres de l'application web et de l'intégration avec le tunnel 
	<code spellcheck="false">
		guacd
	</code>
	.
</p>
<figure class="table">
	<table>
		<thead>
			<tr>
				<th style=";">
					<strong>
						Variable
					</strong>
				</th>
				<th style=";">
					<strong>
						Description
					</strong>
				</th>
				<th style=";">
					<strong>
						Valeur par défaut
					</strong>
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							GUACAMOLE_PORT
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Port d'écoute de l'interface web.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							8080
						</span>
					</code>
				</td>
			</tr>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							GUACD_HOSTNAME
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Nom d'hôte du service 
					</span>
					<code spellcheck="false">
						<span>
							guacd
						</span>
					</code>
					<span>
						.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							guacamole-guacd
						</span>
					</code>
				</td>
			</tr>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							REMOTE_IP_VALVE_ENABLED
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Active le support des headers Proxy (ex: Nginx/Traefik).
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							true
						</span>
					</code>
				</td>
			</tr>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							POSTGRESQL_ENABLED
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Active l'authentification via PostgreSQL.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							true
						</span>
					</code>
				</td>
			</tr>
		</tbody>
	</table>
</figure>
<h4>
	🎥 Enregistrements (Session Recording)
</h4>
<figure class="table">
	<table>
		<thead>
			<tr>
				<th style=";">
					<strong>
						Variable
					</strong>
				</th>
				<th style=";">
					<strong>
						Description
					</strong>
				</th>
				<th style=";">
					<strong>
						Valeur par défaut
					</strong>
				</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							RECORDING_ENABLED
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Active l'enregistrement des sessions.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							true
						</span>
					</code>
				</td>
			</tr>
			<tr>
				<td style=";">
					<code spellcheck="false">
						<span>
							RECORDING_SEARCH_PATH
						</span>
					</code>
				</td>
				<td style=";">
					<span>
						Chemin de stockage des enregistrements.
					</span>
				</td>
				<td style=";">
					<code spellcheck="false">
						<span>
							/record
						</span>
					</code>
				</td>
			</tr>
		</tbody>
	</table>
</figure>
<hr>
<h3>
	🔐 Authentification OpenID (Optionnel)
</h3>
<p>
	Ces variables permettent d'activer le SSO via un fournisseur d'identité (IdP) externe.
</p>
<blockquote>
	<p>
		<strong>
			Note :
		</strong>
		 Actuellement commentées dans la configuration de base.
	</p>
</blockquote>
<ul>
	<li data-list-item-id="e19872f72aefed7290d8e95cdadba9a12">
		<code spellcheck="false">
			OPENID_AUTHORIZATION_ENDPOINT
		</code>
		 : Point d'entrée de l'autorisation de l'IdP.
	</li>
	<li data-list-item-id="e872ffa34bee38e83681e6d321e4db69e">
		<code spellcheck="false">
			OPENID_CLIENT_ID
		</code>
		 : Identifiant client enregistré auprès de l'IdP.
	</li>
	<li data-list-item-id="eebe6c9142b1a279e2e1b284c88a7b597">
		<code spellcheck="false">
			OPENID_REDIRECT_URI
		</code>
		 : URL de redirection après authentification.
	</li>
	<li data-list-item-id="ea90fee5c96298ad29698110744778f7b">
		<code spellcheck="false">
			EXTENSION_PRIORITY
		</code>
		 : Définit l'ordre de priorité des méthodes de login (ex: 
		<code spellcheck="false">
			*,openid
		</code>
		).
	</li>
</ul>
<hr>
<h2>
	🚀 Utilisation Rapide
</h2>
<ol>
	<li data-list-item-id="ebd4af825834627d064fbf6b452826c52">
		<strong>
			Sécurité :
		</strong>
		 Modifiez impérativement le 
		<code spellcheck="false">
			POSTGRESQL_PASSWORD
		</code>
		 avant le déploiement.
	</li>
	<li data-list-item-id="ede6a022b826f59dc3245e46e4db728d7">
		<strong>
			Persistance :
		</strong>
		 Assurez-vous que les dossiers définis dans 
		<code spellcheck="false">
			PGDATA
		</code>
		 et 
		<code spellcheck="false">
			RECORDING_SEARCH_PATH
		</code>
		 ont les droits d'écriture nécessaires sur l'hôte.
	</li>
	<li class="ck-list-marker-bold" data-list-item-id="e6b786ba75297e9822bd2c89f348aa56f">
		<p>
			<strong>
				Déploiement :
			</strong>
		</p>
		<p>
			<response-element>
				<code-block class="ng-tns-c372094400-21 ng-star-inserted" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _nghost-ng-c372094400="">
					<div class="code-block ng-tns-c372094400-21 ng-animate-disabled ng-trigger ng-trigger-codeBlockRevealAnimation" style="display:block;font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="" jslog="223238;track:impression,attention;BardVeMetadataKey:[[&quot;r_ec8567d7c23f2c2d&quot;,&quot;c_f81e699730e8abff&quot;,null,&quot;rc_79d47dae5635e4fe&quot;,null,null,&quot;fr&quot;,null,1,null,null,1,0]]" data-hveid="0" decode-data-ved="1" data-ved="0CAAQhtANahcKEwib4fD86LCSAxUAAAAAHQAAAAAQVA">
						<div class="code-block-decoration header-formatted gds-title-s ng-tns-c372094400-21 ng-star-inserted" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="">
							<span class="ng-tns-c372094400-21" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="">
								Bash
							</span>
							<div class="buttons ng-tns-c372094400-21 ng-star-inserted" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="">
								<button class="mdc-icon-button mat-mdc-icon-button mat-mdc-button-base mat-mdc-tooltip-trigger copy-button ng-tns-c372094400-21 mat-unthemed ng-star-inserted" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="" aria-label="Copier le code" mat-icon-button="" mattooltip="Copier le code" mat-ripple-loader-uninitialized="" mat-ripple-loader-class-name="mat-mdc-button-ripple" mat-ripple-loader-centered="" jslog="179062;track:generic_click,impression;BardVeMetadataKey:[[&quot;r_ec8567d7c23f2c2d&quot;,&quot;c_f81e699730e8abff&quot;,null,&quot;rc_79d47dae5635e4fe&quot;,null,null,&quot;fr&quot;,null,1,null,null,1,0]];mutable:true">
								</button>
							</div>
						</div>
						<div class="formatted-code-block-internal-container ng-tns-c372094400-21" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="">
							<div class="animated-opacity ng-tns-c372094400-21" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="">
								<pre class="ng-tns-c372094400-21" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="">
									<code class="code-container formatted ng-tns-c372094400-21" style="font-family:&quot;Google Sans Text&quot;, sans-serif !important;line-height:1.15 !important;margin-top:0px !important;" _ngcontent-ng-c372094400="" role="text" data-test-id="code-content">
										docker-compose up -d
									</code>
								</pre>
							</div>
						</div>
					</div>
				</code-block>
			</response-element>
		</p>
	</li>
</ol>