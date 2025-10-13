import { Routes } from '@angular/router';


export const routes: Routes = [
    { path: 'about', loadComponent: () => import('./pages/login/login').then(m => ) }
];
