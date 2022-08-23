#!/bin/bash
echo "1 - Inicializando o Gerenciador de Pacotes"
sleep 0.5
yarn init -y
echo "2 - Add+ Dependências de Desenvolvimento Básicas"
sleep 0.5
yarn add -D typescript ts-node-dev @types/express @types/node
echo "3 - Add+ Dependências Básicas"
sleep 0.5
yarn add express typeorm reflect-metadata pg dotenv express-async-errors
echo "4 - Inicializando as Configurações do TypeScript"
sleep 0.5
yarn tsc --init
echo "5 - Criando uma Estrutura de Pastas pelo Terminal"
sleep 0.5
mkdir src
mkdir @types
mkdir @types/express
touch .env .env.example .gitignore @types/express/index.d.ts
mkdir src/controllers
mkdir src/entities
mkdir src/errors
mkdir src/interfaces
mkdir src/middlewares
mkdir src/migrations
mkdir src/routes
mkdir src/services
mkdir src/utils 
touch src/app.ts src/data-source.ts src/routes/index.ts
echo "6 - Editando tsconfig.json (Verificar parametros após finalizr)"
sleep 1.5
echo "{
  \"compilerOptions\": {
    \"target\": \"es2016\",
    \"experimentalDecorators\": true,
    \"emitDecoratorMetadata\": true,
    \"module\": \"commonjs\",
    \"typeRoots\": [\"./node_modules/@types\", \"@types\"],
    \"outDir\": \"./dist\",
    \"esModuleInterop\": true,
    \"forceConsistentCasingInFileNames\": true,
    \"strict\": true,
    \"strictPropertyInitialization\": false,
    \"skipLibCheck\": true
  }
}" > tsconfig.json 
echo "7 - .gitignore Básico"
sleep 0.5
echo "/node_modules
/dist
.env" >> .gitignore
echo "8 - Editando package.json"
sleep 1.5
echo "{
  \"name\": \""${PWD##*/}"\",
  \"version\": \"1.0.0\",
  \"main\": \"app.ts\",
  \"license\": \"MIT\",
  \"scripts\": {
    \"dev\": \"tsnd --respawn --transpile-only src/app.ts\",
    \"typeorm\": \"typeorm-ts-node-commonjs\"
  },
  \"devDependencies\": {
    \"@types/express\": \"^4.17.13\",
    \"@types/node\": \"^18.7.11\",
    \"ts-node-dev\": \"^2.0.0\",
    \"typescript\": \"^4.7.4\"
  },
  \"dependencies\": {
    \"dotenv\": \"^16.0.1\",
    \"express\": \"^4.18.1\",
    \"express-async-errors\": \"^3.1.1\",
    \"pg\": \"^8.7.3\",
    \"reflect-metadata\": \"^0.1.13\",
    \"typeorm\": \"^0.3.7\"
  }
}" > package.json
echo "9 - Configuração Básica: Variáveis de Ambiente"
sleep 2s
echo "digite o usuario postgres"
read username
echo "digite o password postgres"
read password
echo "digite o nome do banco de dados (lowerCase Only)"
read database
echo "digite a porta do servidor local"
read port
sleep 1s
psql -U $username -c "CREATE DATABASE $database;"
echo "POSTGRES_USER=\"seuUsuarioPostgres\"
POSTGRES_PWD=\"suaSenhaPostgres\"
POSTGRES_DB=\"suaDatabasePostgres\"" > .env.example
echo "10 - Configuração Básica: DataSource (TypeORM)"
sleep 1
echo "POSTGRES_USER=\"$username\"
POSTGRES_PWD=\"$password\"
POSTGRES_DB=\"$database\"" > .env
echo "import { DataSource } from \"typeorm\";
import \"dotenv/config\"
    
    export const AppDataSource = new DataSource({
        type: \"postgres\",
        host: \"localhost\",
        port: 5432,
        username: process.env.POSTGRES_USER,
        password: process.env.POSTGRES_PWD,
        database: process.env.POSTGRES_DB,
        synchronize: false,
        logging: true,
        entities: [\"src/entities/*.ts\"],
        migrations: [\"src/migrations/*.ts\"],
    })
    
    AppDataSource.initialize()
        .then(() => {
            console.log(\"Data Source initialized\")
        })
        .catch((err) => {
            console.error(\"Error during Data Source initialization\", err)
        })         " > src/data-source.ts
echo "11 - Tratamento de Erros e o AppError"
sleep 1
echo "    export class AppError extends Error {

        statusCode
    
        constructor(statusCode: number, message: string) {
            super()
            this.statusCode = statusCode
            this.message = message
        }
    }" > src/errors/appError.ts
echo "12 - Middleware Básico para Tratamento de Erros"
sleep 1
echo "import { Request, Response, NextFunction } from \"express\" 
import { AppError } from \"../errors/appError\";

export const errorMiddleware = (err: any, request: Request, response: Response, _: NextFunction) => {
    
    if (err instanceof AppError) {
    return response.status(err.statusCode).json({
        status: \"error\",
        code: err.statusCode,
        message: err.message,
    });
    }

    console.error(err);

    return response.status(500).json({
    status: \"error\",
    code: 500,
    message: \"Internal server error\",
    });
}" > src/middlewares/error.middleware.ts
echo "13 - Roteamento Básico"
sleep .5
echo "    import { Express } from \"express\"
    
    export const appRoutes = (app: Express) => {
    
    }  " > src/routes/index.ts
echo "14 - app.ts Básico"
sleep 1
echo "import express from \"express\"
    import { appRoutes } from \"./routes\"
    import { errorMiddleware } from \"./middlewares/error.middleware\"
    import { Request, Response } from \"express\"
    
    const app = express()
    const port = $port
    
    app.use(express.json())
    
    appRoutes(app)
    
    app.get(\"/\", (req: Request, res: Response) => {
        
        res.status(200).json({
            message: \"Hello World\"
        })
    })
    
    app.use(errorMiddleware)
    
    app.listen(port, () => {
        console.log(\`Server running on port \${port}\`)
    })" > src/app.ts
echo "15 - Criação da Primeira Migration"
sleep 1.5
yarn typeorm migration:create src/migrations/initialMigration
sleep 2.5
yarn typeorm migration:run -d src/data-source.ts
echo "16 - Modelo Básico de Service"
sleep .5
echo "export const myService = async () => {

}

export default myService" > src/services/model.service.ts
echo "17 - Modelo Básico de Controller"
sleep .5
echo "const myController = async (req: Request, res: Response) => {
    
}
    
export const myController" > src/controllers/model.controller.ts
echo "TESTANDO SERVIDOR"
sleep .5
echo "localhost:$port"
sudo lsof -t -i tcp:$port | xargs kill -9
yarn dev

echo "Script Desenvolvido por https://github.com/guicrocetti"
fi