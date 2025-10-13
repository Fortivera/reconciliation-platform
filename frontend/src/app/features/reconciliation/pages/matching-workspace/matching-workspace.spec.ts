import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MatchingWorkspace } from './matching-workspace';

describe('MatchingWorkspace', () => {
  let component: MatchingWorkspace;
  let fixture: ComponentFixture<MatchingWorkspace>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MatchingWorkspace]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MatchingWorkspace);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
